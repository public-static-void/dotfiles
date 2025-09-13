local utils = require("user.utils")

local handlers = utils.safe_require("user.configs.lsp.handlers")
if not handlers then
	return
end

local filetypes = { "php" }

--- List of root marker files/directories to determine the PHP project root.
local root_markers = { "composer.json", ".git", ".phpactor.json", ".phpactor.yml" }

--- Finds the root directory of the current PHP project.
--- This prevents multiple servers starting for subdirectories and aligns with phpactor expectations.
---@param bufnr number Buffer number
---@param on_dir function Callback that takes the root directory path
local function root_dir(bufnr, on_dir)
	local filepath = vim.api.nvim_buf_get_name(bufnr)
	if not filepath or filepath == "" then
		on_dir(vim.loop.cwd())
		return
	end

	local root = utils.find_root(filepath, root_markers)
	on_dir(root or vim.loop.cwd())
end

local cmd = { "phpactor", "language-server" }

return {
	cmd = cmd,
	filetypes = filetypes,
	root_dir = root_dir,
	root_markers = root_markers,
	workspace_required = true,
	on_attach = handlers.on_attach,
	capabilities = handlers.capabilities,
}
