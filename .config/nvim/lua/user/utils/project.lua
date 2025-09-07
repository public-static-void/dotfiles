--- Project root detection utilities.
--- Walks upward from a starting path to find a directory containing
--- root marker files (e.g., .git, package.json).
--- @class Project
local uv = vim.loop
local fs = require("user.utils.fs")
local M = {}

--- Check if directory contains root marker files.
--- @param path string Directory path.
--- @param markers string[] List of marker filenames.
--- @return boolean
local function contains_marker(path, markers)
	for _, marker in ipairs(markers) do
		if fs.exists(fs.join(path, marker)) then
			return true
		end
	end
	return false
end

--- Check if the given directory is a filesystem root ("/" or "C:\").
--- @param dir string Directory path.
--- @return boolean
local function at_fs_root(dir)
	local sep = package.config:sub(1, 1)
	local norm = fs.normalize(dir)
	if not norm then
		return true
	end
	if sep == "/" then
		return norm == "/"
	else
		return norm:match("^%a:" .. sep .. "?$") ~= nil
	end
end

--- Find the root directory by walking up from a given start path.
--- Stops when a directory containing one of the root markers is found,
--- otherwise falls back to the current working directory.
--- @param start_path string File or directory path to start from.
--- @param root_markers string[] List of filenames that mark the root.
--- @return string root The resolved root path.
function M.find_root(start_path, root_markers)
	assert(type(root_markers) == "table" and #root_markers > 0, "root_markers must be a non-empty table")

	if type(start_path) ~= "string" or start_path == "" or not fs.exists(start_path) then
		return uv.cwd()
	end

	local stat = uv.fs_stat(start_path)
	local current = (stat and stat.type == "directory") and fs.normalize(start_path) or fs.parent(start_path)

	while current do
		if contains_marker(current, root_markers) then
			return current
		end
		if at_fs_root(current) then
			break
		end
		local parent = fs.parent(current)
		if not parent or parent == current then
			break
		end
		current = parent
	end

	return uv.cwd()
end

return M
