local utils = require("user.utils")

local handlers = utils.safe_require("user.lsp.handlers")
if not handlers then
	return
end

--- Root markers to identify the project root
local root_markers = { "package.json", ".git" }

--- Determines root directory by searching for root markers upwards
---@param bufnr number
---@param on_dir function
local function root_dir(bufnr, on_dir)
	local filepath = vim.api.nvim_buf_get_name(bufnr)
	if not filepath or filepath == "" then
		on_dir(vim.loop.cwd())
		return
	end
	local root = utils.find_root(filepath, root_markers)
	on_dir(root or vim.loop.cwd())
end

local cmd = { "svelteserver", "--stdio" }
local filetypes = { "svelte" }
local single_file_support = true

--- Command to migrate to Svelte 5 syntax
local function migrate_to_svelte_5()
	local clients = vim.lsp.get_clients({
		bufnr = 0,
		name = "svelte",
	})
	for _, client in ipairs(clients) do
		client:exec_cmd({
			command = "migrate_to_svelte_5",
			arguments = { vim.uri_from_bufnr(0) },
		})
	end
end

return {
	cmd = cmd,
	filetypes = filetypes,
	root_dir = root_dir,
	single_file_support = single_file_support,
	on_attach = handlers.on_attach,
	capabilities = handlers.capabilities,
	commands = {
		MigrateToSvelte5 = {
			migrate_to_svelte_5,
			description = "Migrate Component to Svelte 5 Syntax",
		},
	},
}
