local status_ok, lsp_installer = pcall(require, "mason")
if not status_ok then
  return
end

local config_status_ok, lsp_config = pcall(require, "mason-lspconfig")
if not config_status_ok then
  return
end

local lspconfig = require("lspconfig")

local servers = {
  "clangd",
  "cssls",
  "emmet_ls",
  "eslint",
  "html",
  "jdtls",
  "jsonls",
  "lua_ls",
  "pylsp",
  "pyright",
  "remark_ls",
  "taplo",
  "tsserver",
  "typos_lsp",
  "vimls",
}

lsp_installer.setup({})

lsp_config.setup({
  ensure_installed = servers,
})

for _, server in pairs(servers) do
  local opts = {
    on_attach = require("user.lsp.handlers").on_attach,
    capabilities = require("user.lsp.handlers").capabilities,
  }
  local has_custom_opts, server_custom_opts = pcall(require, "user.lsp.settings." .. server)
  if server == "jdtls" then
    goto continue
  end
  if has_custom_opts then
    opts = vim.tbl_deep_extend("force", opts, server_custom_opts)
  end
  lspconfig[server].setup(opts)
  ::continue::
end
