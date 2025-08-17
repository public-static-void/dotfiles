local utils = require("user.utils")

local handlers = utils.safe_require("user.lsp.handlers")
if not handlers then
	return
end

return {
	on_attach = handlers.on_attach,
	capabilities = handlers.capabilities,
	cmd = { "docker-compose-langserver", "--stdio" },
	filetypes = { "yaml" },
	root_markers = { "docker-compose.yml", ".git" },
}
