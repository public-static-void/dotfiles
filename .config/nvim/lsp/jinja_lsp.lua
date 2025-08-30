local utils = require("user.utils")

local handlers = utils.safe_require("user.lsp.handlers")
if not handlers then
	return
end

local filetypes = {
	"jinja",
	"html.jinja",
	"jinja.html",
}

--- Root marker to identify project root, typically a Git repository.
local root_markers = { ".git" }

--- Locate the root directory for Jinja projects.
---@param bufnr number Buffer number
---@param on_dir fun(path: string) Callback to set root directory
local function root_dir(bufnr, on_dir)
	local filepath = vim.api.nvim_buf_get_name(bufnr)
	if not filepath or filepath == "" then
		on_dir(vim.loop.cwd())
		return
	end
	local root = utils.find_root(filepath, root_markers)
	on_dir(root or vim.loop.cwd())
end

local single_file_support = true

local cmd = { "jinja-lsp" }

return {
	cmd = cmd,
	filetypes = filetypes,
	root_dir = root_dir,
	on_attach = handlers.on_attach,
	capabilities = handlers.capabilities,
	single_file_support = single_file_support,
}
