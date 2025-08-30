vim.lsp.set_log_level("ERROR")

require("user.lsp.configs")
require("user.lsp.handlers").setup()
require("user.lsp.conform")
require("user.lsp.lint")
