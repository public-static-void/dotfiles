--- Central keymaps module aggregating all keymap submodules.
--- Usage: require("user.keymaps") loads all keymaps configuration.

local utils = require("user.utils")

-- Set leader keys early
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Safely load submodules; prevents errors from breaking config load.
local commands = utils.safe_require("user.keymaps.commands") or {}
local editing = utils.safe_require("user.keymaps.editing") or {}
local navigation = utils.safe_require("user.keymaps.navigation") or {}
local window = utils.safe_require("user.keymaps.window") or {}
local tabs = utils.safe_require("user.keymaps.tabs") or {}
local buffers = utils.safe_require("user.keymaps.buffers") or {}
local lsp = utils.safe_require("user.keymaps.lsp") or {}
local terminal = utils.safe_require("user.keymaps.terminal") or {}
local plugins = utils.safe_require("user.keymaps.plugins") or {}

-- Return the modules table in case you want to access them somewhere
return {
	commands = commands,
	editing = editing,
	navigation = navigation,
	window = window,
	tabs = tabs,
	buffers = buffers,
	lsp = lsp,
	terminal = terminal,
	plugins = plugins,
}
