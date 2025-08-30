local utils = require("user.utils")

local handlers = utils.safe_require("user.lsp.handlers")
if not handlers then
	return
end

local filetypes = {
	"html",
	"templ",
}

--- Root markers for HTML projects.
--- Node-based projects often anchor at package.json, fallback to .git for general repos.
local root_markers = { "package.json", ".git" }

--- Root detection using provided utils
---@param bufnr number Buffer number
---@param on_dir function Callback with resolved root directory
local function root_dir(bufnr, on_dir)
	local filepath = vim.api.nvim_buf_get_name(bufnr)
	if not filepath or filepath == "" then
		on_dir(vim.loop.cwd())
		return
	end
	local root = utils.find_root(filepath, root_markers)
	on_dir(root or vim.loop.cwd())
end

--- Init options expand server capabilities:
--- - provideFormatter enables built-in HTML formatting
--- - embeddedLanguages allows completions inside <style> and <script>
--- - configurationSection ensures server is aware of html/css/js settings
local init_options = {
	provideFormatter = true,
	embeddedLanguages = { css = true, javascript = true },
	configurationSection = { "html", "css", "javascript" },
}

local cmd = { "vscode-html-language-server", "--stdio" }

-- Final config passed to vim.lsp.start
return {
	cmd = cmd,
	filetypes = filetypes,
	root_markers = root_markers,
	root_dir = root_dir,
	on_attach = handlers.on_attach,
	capabilities = handlers.capabilities,
	settings = {},
	init_options = init_options,
}
