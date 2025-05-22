local utils = require("user.utils")

local handlers = utils.safe_require("user.lsp.handlers")
if not handlers then
	return
end

return {
	cmd = { "htmx-lsp" },
	filetypes = { "html", "htmx", "typescript" },
	root_markers = { "package.json", ".git" },
	on_attach = handlers.on_attach,
	capabilities = handlers.capabilities,
}
