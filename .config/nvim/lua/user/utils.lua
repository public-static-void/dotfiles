local M = {}

-- Safely load required modules with error handling
function M.safe_require(module)
	local status_ok, lib = pcall(require, module)
	if not status_ok then
		return nil, string.format("Failed to load %s: %s", module, lib)
	end
	return lib
end

return M
