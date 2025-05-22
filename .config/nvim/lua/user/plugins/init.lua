local utils = require("user.utils")

-- Automatically install lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local lazy = utils.safe_require("lazy")
if not lazy then
	return
end

-- Install plugins
local plugins = {}

vim.list_extend(plugins, require("user.plugins.colorschemes"))
vim.list_extend(plugins, require("user.plugins.ui"))
vim.list_extend(plugins, require("user.plugins.treesitter"))
vim.list_extend(plugins, require("user.plugins.lsp"))
vim.list_extend(plugins, require("user.plugins.completion"))
vim.list_extend(plugins, require("user.plugins.dap"))
vim.list_extend(plugins, require("user.plugins.ai"))
vim.list_extend(plugins, require("user.plugins.filetypes"))
vim.list_extend(plugins, require("user.plugins.editing"))
vim.list_extend(plugins, require("user.plugins.project"))

lazy.setup(plugins)
