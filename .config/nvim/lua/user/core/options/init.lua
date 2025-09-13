--- Central options module aggregating all option-related submodules.
--- Usage: requiring this module loads and returns all grouped option configs.
local utils = require("user.utils")

local ui = utils.safe_require("user.core.options.ui") or {}
local editing = utils.safe_require("user.core.options.editing") or {}
local files = utils.safe_require("user.core.options.files") or {}
local performance = utils.safe_require("user.core.options.performance") or {}
local providers = utils.safe_require("user.core.options.providers") or {}

return {
	ui = ui,
	editing = editing,
	files = files,
	performance = performance,
	providers = providers,
}
