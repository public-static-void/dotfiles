local utils = require("user.utils")

local handlers = utils.safe_require("user.lsp.handlers")
if not handlers then
	return
end

return {
	on_attach = handlers.on_attach,
	capabilities = handlers.capabilities,
	cmd = { "haskell-language-server-wrapper", "--lsp" },
	filetypes = { "haskell", "lhaskell", "cabal" },
	root_markers = { "hie.yaml", "stack.yaml", "cabal.project", "package.yaml", ".git" },
}
