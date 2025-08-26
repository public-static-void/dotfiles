local utils = require("user.utils")

local handlers = utils.safe_require("user.lsp.handlers")
if not handlers then
	return
end

--- Emmet is useful in many filetypes, not just plain HTML.
--- This list covers modern frontend frameworks, template systems, and style preprocessors.
local filetypes = {
	"astro",
	"css",
	"eruby",
	"html",
	"htmlangular",
	"htmldjango",
	"javascriptreact",
	"less",
	"pug",
	"sass",
	"scss",
	"svelte",
	"templ",
	"typescriptreact",
	"vue",
}

--- Root markers.
--- While Emmet doesn’t strictly need a project root, we fall back to .git to stay consistent.
local root_markers = { ".git" }

--- Root detection integrates with utils.find_root but defaults safely to cwd.
---@param bufnr number Buffer number
---@param on_dir function Callback invoked with resolved root dir
local function root_dir(bufnr, on_dir)
	local filepath = vim.api.nvim_buf_get_name(bufnr)
	if not filepath or filepath == "" then
		on_dir(vim.loop.cwd())
		return
	end
	local root = utils.find_root(filepath, root_markers)
	on_dir(root or vim.loop.cwd())
end

-- Final Emmet LSP configuration
return {
	cmd = { "emmet-ls", "--stdio" },
	filetypes = filetypes,
	root_markers = root_markers,
	root_dir = root_dir,
	on_attach = handlers.on_attach,
	capabilities = handlers.capabilities,
}
