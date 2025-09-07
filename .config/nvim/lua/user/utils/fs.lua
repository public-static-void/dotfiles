--- Cross-platform filesystem helper utilities.
--- Provides functions for safely joining paths, checking existence,
--- and working with parent directories.
--- @class FS
local uv = vim.loop
local M = {}

--- Check if a path exists in the filesystem.
--- @param path string Path to check.
--- @return boolean exists True if the path exists.
function M.exists(path)
	return type(path) == "string" and path ~= "" and uv.fs_stat(path) ~= nil
end

--- Join multiple path components with the correct OS-specific separator.
--- Uses native vim.fs.joinpath if available (Neovim ≥0.9).
--- @param ... string Path components.
--- @return string path The joined filesystem path.
function M.join(...)
	if vim.fs and vim.fs.joinpath then
		return vim.fs.joinpath(...)
	end
	local sep = package.config:sub(1, 1)
	return table.concat({ ... }, sep)
end

--- Normalize a path by stripping trailing separators.
--- @param path string
--- @return string|nil normalized Normalized path, or nil if invalid.
function M.normalize(path)
	if type(path) ~= "string" or path == "" then
		return nil
	end
	local sep = package.config:sub(1, 1)
	if path:sub(-1) == sep then
		return path:sub(1, -2)
	end
	return path
end

--- Get the parent directory of a given path.
--- @param path string Absolute or relative path.
--- @return string|nil parent Parent directory, or nil if none.
function M.parent(path)
	local sep = package.config:sub(1, 1)
	local normalized = M.normalize(path)
	if not normalized then
		return nil
	end
	local parent = normalized:match("^(.*)" .. sep)
	if parent and parent:sub(-1) == sep then
		return parent:sub(1, -2)
	end
	return parent
end

--- Create a directory if it does not exist.
--- Equivalent to `mkdir -m 700` on Unix.
--- @param dir string Directory path to enforce.
--- @return boolean ok True if directory exists or was created successfully.
function M.mkdir_if_not_exists(dir)
	if not M.exists(dir) then
		local ok, err = uv.fs_mkdir(dir, 448) -- 0700 in decimal
		if not ok then
			vim.notify("Could not create directory: " .. dir .. "\nError: " .. (err or "unknown"), vim.log.levels.WARN)
			return false
		end
	end
	return true
end

return M
