--- Java-specific utility functions for Neovim configuration.
--- Provides helpers to locate JAR bundles and construct classpaths,
--- useful for language server setup (e.g., Eclipse JDT LS).
--- @class JavaUtils
local uv = vim.loop
local fs = require("user.utils.fs")
local M = {}

--- Recursively find Java bundle JARs from given glob patterns.
--- Filters out known unwanted jars like jacocoagent.
--- @param patterns string[] List of Vim glob patterns to search.
--- @return string[] bundles List of matching JAR file paths.
function M.find_bundles(patterns)
	local acc = {}
	for _, pat in ipairs(patterns) do
		for _, f in ipairs(vim.fn.glob(pat, true, true)) do
			if not f:match("jacocoagent%.jar") and not f:match("test%.runner%-jar%-with%-dependencies%.jar") then
				table.insert(acc, f)
			end
		end
	end
	return acc
end

--- Build a classpath string containing all .jar files in a directory.
--- Classpath entries are colon-separated (Unix convention).
--- @param jar_dir string Directory containing .jar files.
--- @return string classpath Colon-separated list of JAR paths.
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
				table.insert(jars, fs.join(jar_dir, name))
			end
		end
	end
	return table.concat(jars, ":")
end

return M
