local M = {}

local uv = vim.loop

--- Safely require a module and handle errors gracefully.
-- @param module string The module name to require.
-- @return table|nil The loaded module or nil if loading failed.
-- @return string|nil Error message if failed, otherwise nil.
function M.safe_require(module)
	local status_ok, lib = pcall(require, module)
	if not status_ok then
		return nil, string.format("Failed to load %s: %s", module, lib)
	end
	return lib
end

M.host = "127.0.0.1"
M.port = "11434"
M.preferred_model = "codegemma:2b"
-- M.preferred_model = "codellama:7b-code"
-- M.preferred_model = "qwen2.5-coder:7b-base-q6_K"

-- Store the current model for each plugin
M.current_models = {}

-- Check if Ollama is running
function M.is_ollama_available()
	local is_windows = (vim.uv and vim.uv.os_uname and vim.uv.os_uname().sysname == "Windows_NT")
	local handle
	if is_windows then
		-- Use PowerShell to check for 'ollama serve' process on Windows
		handle = io.popen(
			[[powershell -Command "Get-Process | Where-Object { $_.Path -like '*ollama*' -and $_.Path -like '*serve*' }"]]
		)
	else
		handle = io.popen("pgrep -f 'ollama serve'")
	end
	if not handle then
		return false
	end
	local result = handle:read("*a")
	handle:close()
	if result == "" then
		return false
	end

	handle = io.popen("curl -s --connect-timeout 2 http://" .. M.host .. ":" .. M.port .. "/api/tags")
	if not handle then
		return false
	end
	result = handle:read("*a")
	handle:close()
	return result ~= ""
end

-- Fetch available models from API
function M.get_available_models(caller)
	if not M.is_ollama_available() then
		print(string.format("[%s] Ollama is not available. Please start it first.", caller or "Unknown"))
		return {}
	end

	local url = "http://" .. M.host .. ":" .. M.port .. "/api/tags"
	local handle = io.popen("curl -s --connect-timeout 5 " .. url)
	if handle then
		local response = handle:read("*a")
		handle:close()
		if response and response ~= "" then
			local json = vim.json.decode(response)
			if json then
				return json.models and vim.tbl_map(function(model)
					return model.model
				end, json.models) or {}
			else
				print("[" .. caller .. "] Error decoding JSON response")
				return {}
			end
		else
			print("[" .. caller .. "] Error fetching data or endpoint not found")
			return {}
		end
	else
		print("[" .. caller .. "] Failed to execute curl command")
		return {}
	end
end

-- Let user select a model using vim.ui.select
function M.select_model(models, caller, callback)
	local current_model = M.current_models[caller] or "Not set"
	vim.ui.select(models, {
		prompt = "Select a model (Current: " .. current_model .. "):",
		format_item = function(item)
			return item
		end,
	}, function(choice)
		if choice then
			M.current_models[caller] = choice
			callback(choice)
			vim.schedule(function()
				print("[" .. caller .. "] Now using model: " .. choice)
			end)
		else
			print("[" .. caller .. "] No model selected. Keeping current model: " .. current_model)
		end
	end)
end

-- Use preferred model if available, otherwise prompt for selection
function M.use_or_select_model(caller, callback)
	local available_models = M.get_available_models(caller)
	if #available_models > 0 then
		local preferred_model_available = false
		for _, model in ipairs(available_models) do
			if model == M.preferred_model then
				preferred_model_available = true
				M.current_models[caller] = model
				print("[" .. caller .. "] Using preferred model: " .. model)
				callback(model)
				return
			end
		end
		if not preferred_model_available then
			print("[" .. caller .. "] " .. M.preferred_model .. " not available. Please select a model:")
			M.select_model(available_models, caller, callback)
		end
	else
		print("[" .. caller .. "] No models available")
	end
end

-- Get the current model for a caller
function M.get_current_model(caller)
	return M.current_models[caller] or "Not set"
end

-- Find Java bundles recursively
function M.find_bundles(patterns)
	local acc = {}
	for _, pat in ipairs(patterns) do
		for _, f in ipairs(vim.fn.glob(pat, true, true)) do
			if not f:match("jacocoagent.jar") and not f:match("test.runner-jar-with-dependencies.jar") then
				table.insert(acc, f)
			end
		end
	end
	return acc
end

--- Check if path exists in filesystem.
-- @param path string
-- @return boolean
local function path_exists(path)
	if type(path) ~= "string" or path == "" then
		return false
	end
	return uv.fs_stat(path) ~= nil
end

--- Join multiple path parts respecting OS separator.
-- @param ... string Path parts
-- @return string Joined path
local function path_join(...)
	local sep = package.config:sub(1, 1)
	return table.concat({ ... }, sep)
end

--- Get parent directory of a given path.
-- @param path string
-- @return string|nil Parent or nil if none
local function parent_dir(path)
	if type(path) ~= "string" or path == "" then
		return nil
	end
	local sep = package.config:sub(1, 1)
	local normalized = path
	if path:sub(-1) == sep then
		normalized = path:sub(1, -2)
	end
	local parent = normalized:match("^(.*)" .. sep)
	if parent and parent ~= "" then
		if parent:sub(-1) == sep then
			return parent:sub(1, -2)
		end
		return parent
	end
	return nil
end

--- Normalize path by trimming trailing separator.
-- @param path string
-- @return string|nil Normalized path
local function normalize_path(path)
	if type(path) ~= "string" or path == "" then
		return nil
	end
	local sep = package.config:sub(1, 1)
	if path:sub(-1) == sep then
		return path:sub(1, -2)
	end
	return path
end

--- Check if directory contains any root markers.
-- @param path string Dir path
-- @param markers table List of filenames
-- @return boolean
local function contains_root_marker(path, markers)
	for _, marker in ipairs(markers) do
		if path_exists(path_join(path, marker)) then
			return true
		end
	end
	return false
end

--- Check if directory is a filesystem root.
-- @param dir string Directory
-- @return boolean
local function at_fs_root(dir)
	local sep = package.config:sub(1, 1)
	local norm_dir = normalize_path(dir)
	if not norm_dir then
		return true
	end
	if sep == "/" then
		return norm_dir == "/"
	else
		return norm_dir:match("^%a:" .. sep .. "?$") ~= nil
	end
end

--- Find the root directory starting from start_path by walking up
-- until a directory with a root marker is found, or returns cwd.
-- @param start_path string File or directory path
-- @param root_markers table Non-empty list of markers
-- @return string Root path or cwd fallback
function M.find_root(start_path, root_markers)
	assert(type(root_markers) == "table" and #root_markers > 0, "root_markers must be non-empty table")

	if type(start_path) ~= "string" or start_path == "" or not path_exists(start_path) then
		return uv.cwd()
	end

	local stat = uv.fs_stat(start_path)
	local current
	if stat and stat.type ~= "directory" then
		current = normalize_path(parent_dir(start_path))
		if not current then
			return uv.cwd()
		end
	else
		current = normalize_path(start_path)
	end

	while current do
		if contains_root_marker(current, root_markers) then
			return current
		end
		if at_fs_root(current) then
			break
		end
		local parent = parent_dir(current)
		if not parent or parent == current then
			break
		end
		current = parent
	end

	return uv.cwd()
end

--- Build Java classpath string from all jar files in directory.
-- @param jar_dir string Path containing jars
-- @return string Classpath joined by ':' (Unix)
function M.build_classpath(jar_dir)
	local jars = {}
	local iter = uv.fs_scandir(jar_dir)
	if iter then
		while true do
			local name = uv.fs_scandir_next(iter)
			if not name then
				break
			end
			if name:match("%.jar$") then
				table.insert(jars, jar_dir .. "/" .. name)
			end
		end
	end
	return table.concat(jars, ":")
end

return M
