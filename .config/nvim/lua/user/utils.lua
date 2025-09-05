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
-- Uses native vim.fs.joinpath if available (Neovim 0.9+), otherwise falls back.
-- @param ... string Path parts
-- @return string Joined path
local function path_join(...)
	if vim.fs and vim.fs.joinpath then
		return vim.fs.joinpath(...)
	end
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
-- Uses improved path_join and normalization.
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
				table.insert(jars, path_join(jar_dir, name))
			end
		end
	end
	return table.concat(jars, ":")
end

return M
