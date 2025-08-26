local utils = require("user.utils")

local handlers = utils.safe_require("user.lsp.handlers")
if not handlers then
	return
end

--- Markers used to identify the project root directory
local root_markers = { "package.json", ".git" }

--- Detect the root directory by looking for root markers upwards from current buffer
---@param bufnr number Buffer number
---@param on_dir function Callback to set root directory
local function root_dir(bufnr, on_dir)
	local filepath = vim.api.nvim_buf_get_name(bufnr)
	if not filepath or filepath == "" then
		on_dir(vim.loop.cwd())
		return
	end
	local root = utils.find_root(filepath, root_markers)
	on_dir(root or vim.loop.cwd())
end

local cmd = { "htmx-lsp" }
local filetypes = {
	"aspnetcorerazor",
	"astro",
	"astro-markdown",
	"blade",
	"clojure",
	"django-html",
	"htmldjango",
	"edge",
	"eelixir",
	"elixir",
	"ejs",
	"erb",
	"eruby",
	"gohtml",
	"gohtmltmpl",
	"haml",
	"handlebars",
	"hbs",
	"html",
	"htmlangular",
	"html-eex",
	"heex",
	"jade",
	"leaf",
	"liquid",
	"markdown",
	"mdx",
	"mustache",
	"njk",
	"nunjucks",
	"php",
	"razor",
	"slim",
	"twig",
	"javascript",
	"javascriptreact",
	"reason",
	"rescript",
	"typescript",
	"typescriptreact",
	"vue",
	"svelte",
	"templ",
}

return {
	cmd = cmd,
	filetypes = filetypes,
	root_dir = root_dir,
	single_file_support = true,
	on_attach = handlers.on_attach,
	capabilities = handlers.capabilities,
}
