--- Central plugin loader
-- Assembles all plugin specifications from submodules under `user.core.plugins.*`.
-- Uses `utils.safe_require` to prevent startup errors if a module is missing.

local utils = require("user.utils")

local commands = utils.safe_require("user.core.plugins.commands")
if not commands then
	return
end

--- List of plugin specification modules
--- @type string[]
local modules = {
	"user.core.plugins.colorschemes",
	"user.core.plugins.ui",
	"user.core.plugins.lsp",
	"user.core.plugins.completion",
	"user.core.plugins.dap",
	"user.core.plugins.filetypes",
	"user.core.plugins.editing",
	"user.core.plugins.project",
}

local plugins = {}

for _, module in ipairs(modules) do
	local spec = utils.safe_require(module)
	if spec then
		vim.list_extend(plugins, spec)
	end
end

-- Initialize vim.pack plugin manager with all specs
vim.pack.add(plugins)

local names = {}
for _, spec in ipairs(plugins) do
	table.insert(names, spec[1])
end

commands.set_plugin_names(names)
