local utils = require("user.utils")

-- NOTE:
-- This file bootstraps the plugin manager (lazy.nvim) and assembles all plugin
-- specifications from submodules under `user.plugins.*`.
--
-- If `lazy.nvim` is not installed locally, it will automatically attempt a
-- shallow clone from GitHub. This ensures a reproducible environment without
-- requiring manual plugin manager setup.

--- Path separator (system-dependent, `\` on Windows, `/` elsewhere)
--- @type string
local sep = package.config:sub(1, 1)

--- Full path where lazy.nvim should be installed
--- @type string
local lazypath = vim.fn.stdpath("data") .. sep .. "lazy" .. sep .. "lazy.nvim"

-- Bootstrap lazy.nvim if missing
if not vim.uv.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	-- Clone stable branch only; `--filter=blob:none` speeds up clone time
	local out = vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		lazyrepo,
		lazypath,
	})

	-- If cloning fails, print diagnostic and abort startup
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end

-- Ensure lazy.nvim is available in runtime path
vim.opt.rtp:prepend(lazypath)

--- Safe require wrapper to avoid errors if lazy.nvim cannot be loaded.
--- @type Lazy | nil
local lazy = utils.safe_require("lazy")
if not lazy then
	return
end

-- Assemble plugin specifications
-- Plugin specs are modularized per category (colorschemes, UI, LSP, etc.)
--- @type Plugin[]
local plugins = {}

vim.list_extend(plugins, require("user.plugins.colorschemes"))
vim.list_extend(plugins, require("user.plugins.ui"))
vim.list_extend(plugins, require("user.plugins.treesitter"))
vim.list_extend(plugins, require("user.plugins.lsp"))
vim.list_extend(plugins, require("user.plugins.completion"))
vim.list_extend(plugins, require("user.plugins.dap"))
vim.list_extend(plugins, require("user.plugins.filetypes"))
vim.list_extend(plugins, require("user.plugins.editing"))
vim.list_extend(plugins, require("user.plugins.project"))

--- Initialize lazy.nvim plugin manager with all specs
lazy.setup(plugins)
