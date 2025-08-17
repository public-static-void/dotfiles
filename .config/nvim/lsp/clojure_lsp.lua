local utils = require("user.utils")

local handlers = utils.safe_require("user.lsp.handlers")
if not handlers then
	return
end

return {
	on_attach = handlers.on_attach,
	capabilities = handlers.capabilities,
	cmd = { "clojure-lsp" },
	filetypes = { "clojure", "clojurescript", "clojurec" },
	root_markers = { "deps.edn", "project.clj", "shadow-cljs.edn", ".git" },
}
