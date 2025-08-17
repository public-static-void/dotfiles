local utils = require("user.utils")

local handlers = utils.safe_require("user.lsp.handlers")
if not handlers then
	return
end

return {
	on_attach = handlers.on_attach,
	capabilities = handlers.capabilities,
	cmd = { "sqls" },
	filetypes = { "sql" },
	root_markers = { ".git" },
}
