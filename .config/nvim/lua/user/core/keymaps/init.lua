--- Central keymaps module aggregating all keymap submodules.
--- Usage: require("user.keymaps") loads all keymaps configuration.

local utils = require("user.utils")

-- Set leader keys early
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Safely load submodules; prevents errors from breaking config load.
local buffers = utils.safe_require("user.core.keymaps.buffers") or {}
local commands = utils.safe_require("user.core.keymaps.commands") or {}
local dap = utils.safe_require("user.core.keymaps.dap") or {}
local editing = utils.safe_require("user.core.keymaps.editing") or {}
local lsp = utils.safe_require("user.core.keymaps.lsp") or {}
local navigation = utils.safe_require("user.core.keymaps.navigation") or {}
local plugins = utils.safe_require("user.core.keymaps.plugins") or {}
local tabs = utils.safe_require("user.core.keymaps.tabs") or {}
local terminal = utils.safe_require("user.core.keymaps.terminal") or {}
local window = utils.safe_require("user.core.keymaps.window") or {}

-- Return the modules table in case you want to access them somewhere
return {
	buffers = buffers,
	commands = commands,
	dap = dap,
	editing = editing,
	lsp = lsp,
	navigation = navigation,
	plugins = plugins,
	tabs = tabs,
	terminal = terminal,
	window = window,
}
