local M = {}

-- Safely load required modules with error handling
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

return M
