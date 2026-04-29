local utils = require("user.utils")

local handlers = utils.safe_require("user.configs.lsp.handlers")
if not handlers then
	return
end

--- Stimulus is found in diverse environments: Rails (ERB), Laravel (Blade),
--- PHP templates, and frontend TypeScript/JavaScript.
local filetypes = {
	"javascript",
	"typescript",
	"html",
	"eruby", -- Rails embedded Ruby
	"ruby",
	"blade", -- Laravel blade templates
	"php",
}

--- Root markers: Stimulus often lives in Rails repos with Gemfile,
--- but also general JS/TS repos with only .git.
local root_markers = { "Gemfile", ".git" }

--- Determine project root based on markers.
---@param bufnr number Buffer number
---@param on_dir fun(path:string?) Callback with resolved root (may be nil)
local function root_dir(bufnr, on_dir)
	local filepath = vim.api.nvim_buf_get_name(bufnr)
	if not filepath or filepath == "" then
		on_dir(vim.loop.cwd())
		return
	end
	local root = utils.find_root(filepath, root_markers)
	on_dir(root or vim.loop.cwd())
end

local cmd = { "stimulus-language-server", "--stdio" }

return {
	cmd = cmd,
	filetypes = filetypes,
	root_markers = root_markers,
	root_dir = root_dir,
	on_attach = handlers.on_attach,
	capabilities = handlers.capabilities,
}
