--- Central DAP module aggregating adapters, configs, and UI setup.
--- Usage: require("user.dap") loads all dap-related configurations.
local utils = require("user.utils")

local dap = utils.safe_require("dap")
if not dap then
	return nil
end

-- Safe require submodules to make sure errors do not break Neovim config loading.
local adapters = utils.safe_require("user.dap.adapters") or {}
local configs = utils.safe_require("user.dap.configs") or {}
local ui = utils.safe_require("user.dap.ui") or {}

return {
	dap = dap,
	adapters = adapters,
	configs = configs,
	ui = ui,
}
