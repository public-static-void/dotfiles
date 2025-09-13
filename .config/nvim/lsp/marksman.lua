local utils = require("user.utils")

local handlers = utils.safe_require("user.configs.lsp.handlers")
if not handlers then
	return
end

local filetypes = {
	"markdown",
	"markdown.mdx",
}

--- Root markers identifying markdown project root directories.
--- This includes typical version control plus optional Marksman config files.
local root_markers = { ".marksman.toml", ".git" }

--- Determines the project root directory for markdown files.
--- Uses existing utility function for consistency and simplicity.
---@param bufnr number Buffer number
---@param on_dir function Callback receiving detected root directory path
local function root_dir(bufnr, on_dir)
	local filepath = vim.api.nvim_buf_get_name(bufnr)
	if not filepath or filepath == "" then
		on_dir(vim.loop.cwd())
		return
	end
	local root = utils.find_root(filepath, root_markers)
	on_dir(root or vim.loop.cwd())
end

local cmd = { "marksman", "server" }

return {
	cmd = cmd,
	filetypes = filetypes,
	root_dir = root_dir,
	root_markers = root_markers,
	on_attach = handlers.on_attach,
	capabilities = handlers.capabilities,
}
