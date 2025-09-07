-- Central UI module aggregating various UI components.
-- Usage: require("user.ui") loads all UI-related configs.

local utils = require("user.utils")

-- Safe require to avoid config breakage if a module is missing or fails.
local aerial = utils.safe_require("user.ui.aerial") or {}
local alpha = utils.safe_require("user.ui.alpha") or {}
local bufferline = utils.safe_require("user.ui.bufferline") or {}
local colorscheme = utils.safe_require("user.ui.colorscheme") or {}
local cursorword = utils.safe_require("user.ui.cursorword") or {}
local filetree = utils.safe_require("user.ui.filetree") or {}
local gitsigns = utils.safe_require("user.ui.gitsigns") or {}
local indentscope = utils.safe_require("user.ui.indentscope") or {}
local lualine = utils.safe_require("user.ui.lualine") or {}
local picker = utils.safe_require("user.ui.picker") or {}
local toggleterm = utils.safe_require("user.ui.toggleterm") or {}
local whichkey = utils.safe_require("user.ui.whichkey") or {}

return {
	aerial = aerial,
	alpha = alpha,
	bufferline = bufferline,
	colorscheme = colorscheme,
	cursorword = cursorword,
	filetree = filetree,
	gitsigns = gitsigns,
	indentscope = indentscope,
	lualine = lualine,
	picker = picker,
	toggleterm = toggleterm,
	whichkey = whichkey,
}
