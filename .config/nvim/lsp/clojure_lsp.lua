local utils = require("user.utils")

local handlers = utils.safe_require("user.configs.lsp.handlers")
if not handlers then
	return
end

local filetypes = {
	"clojure",
	"clojurescript",
	"clojurec",
}

--- Root markers used to identify the root directory for Clojure projects.
local root_markers = { "deps.edn", "project.clj", "shadow-cljs.edn", ".git" }

--- Find root directory for Clojure projects based on root markers.
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

local cmd = { "clojure-lsp" }

return {
	cmd = cmd,
	filetypes = filetypes,
	root_dir = root_dir,
	on_attach = handlers.on_attach,
	capabilities = handlers.capabilities,
	single_file_support = single_file_support,
}
