local utils = require("user.utils")

local handlers = utils.safe_require("user.lsp.handlers")
if not handlers then
	return
end

return {
	on_attach = handlers.on_attach,
	capabilities = handlers.capabilities,
	cmd = { "ngserver", "--stdio" },
	filetypes = { "typescript", "html" },
	root_markers = { "angular.json", "package.json", "tsconfig.json", ".git" },
}
