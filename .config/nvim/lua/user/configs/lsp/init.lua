vim.lsp.set_log_level("ERROR")

require("user.configs.lsp.configs")
require("user.configs.lsp.handlers").setup()
require("user.configs.lsp.conform")
require("user.configs.lsp.lint")
