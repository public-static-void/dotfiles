--- Module for safe requiring of Lua modules.
--- Helps prevent runtime errors when optional dependencies are missing.
--- @class Modules
local M = {}

--- Safely require a Lua module with error handling.
--- Returns the module if loaded, otherwise returns nil and an error msg.
--- @param module string Name of the module to require.
--- @return any|nil lib The loaded module, or nil if requiring failed.
--- @return string|nil errmsg Error message when failure occurs.
function M.safe_require(module)
	local status_ok, lib = pcall(require, module)
	if not status_ok then
		return nil, string.format("Failed to load %s: %s", module, lib)
	end
	return lib
end

return M
