local utils = require("user.utils")

local lspconfig = pcall(require, "lspconfig")
if not lspconfig then
	return
end

require("user.lsp.configs")
require("user.lsp.handlers").setup()
require("user.lsp.null-ls")
