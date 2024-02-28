local home = os.getenv("HOME")
return {
  filetypes = {
    "*",
  },
  init_options = {
    diagnosticSeverity = "Warning",
    config = home .. "/.config/nvim/lua/user/lsp/settings/typos.toml",
  },
}
