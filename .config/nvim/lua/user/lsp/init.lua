local utils = require("user.utils")

local lspconfig = utils.safe_require("lspconfig")
if not lspconfig then
	return
end

require("user.lsp.configs")
require("user.lsp.handlers").setup()
require("user.lsp.null-ls")
