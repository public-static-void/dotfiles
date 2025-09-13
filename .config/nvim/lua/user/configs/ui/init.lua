-- Central UI module aggregating various UI components.
-- Usage: require("user.ui") loads all UI-related configs.

local utils = require("user.utils")

-- Safe require to avoid config breakage if a module is missing or fails.
local aerial = utils.safe_require("user.configs.ui.aerial") or {}
local alpha = utils.safe_require("user.configs.ui.alpha") or {}
local bufferline = utils.safe_require("user.configs.ui.bufferline") or {}
local colorscheme = utils.safe_require("user.configs.ui.colorscheme") or {}
local cursorword = utils.safe_require("user.configs.ui.cursorword") or {}
local filetree = utils.safe_require("user.configs.ui.filetree") or {}
local gitsigns = utils.safe_require("user.configs.ui.gitsigns") or {}
local indentscope = utils.safe_require("user.configs.ui.indentscope") or {}
local lualine = utils.safe_require("user.configs.ui.lualine") or {}
local picker = utils.safe_require("user.configs.ui.picker") or {}
local rainbow_delimiters = utils.safe_require("user.configs.ui.rainbow_delimiters") or {}
local scrollbar = utils.safe_require("user.configs.ui.scrollbar") or {}
local sunglasses = utils.safe_require("user.configs.ui.sunglasses") or {}
local toggleterm = utils.safe_require("user.configs.ui.toggleterm") or {}
local trouble = utils.safe_require("user.configs.ui.trouble") or {}
local undotree = utils.safe_require("user.configs.ui.undotree") or {}
local whichkey = utils.safe_require("user.configs.ui.whichkey") or {}

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
	rainbow_delimiters = rainbow_delimiters,
	scrollbar = scrollbar,
	sunglasses = sunglasses,
	toggleterm = toggleterm,
	trouble = trouble,
	undotree = undotree,
	whichkey = whichkey,
}
