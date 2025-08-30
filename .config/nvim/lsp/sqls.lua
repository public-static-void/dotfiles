local utils = require("user.utils")

local handlers = utils.safe_require("user.lsp.handlers")
if not handlers then
	return
end

local filetypes = {
	"sql",
	"mysql",
}

--- Root markers for SQL projects.
--- sqls loads config from `.sqllsrc.json` at project root, otherwise falls back to home config.
local root_markers = { ".sqllsrc.json", ".git" }

--- Find project root directory based on root markers.
---@param bufnr number Buffer number
---@param on_dir fun(path:string) Callback with found root directory path
local function root_dir(bufnr, on_dir)
	local filepath = vim.api.nvim_buf_get_name(bufnr)
	if not filepath or filepath == "" then
		on_dir(vim.loop.cwd())
		return
	end
	local root = utils.find_root(filepath, root_markers)
	on_dir(root or vim.loop.cwd())
end

--- Default settings can be augmented to specify database connections and lint rules.
--- For typical usage, the user supplies `.sqllsrc.json` in the project or home directory.
local settings = {}

local cmd = { "sqls" }

return {
	cmd = cmd,
	filetypes = filetypes,
	root_markers = root_markers,
	root_dir = root_dir,
	settings = settings,
	on_attach = handlers.on_attach,
	capabilities = handlers.capabilities,
}
