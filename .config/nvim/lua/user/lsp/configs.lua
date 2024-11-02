local java_status_ok, java = pcall(require, "java")
if not java_status_ok then
	return
end

local status_ok, lsp_installer = pcall(require, "mason")
if not status_ok then
	return
end

local config_status_ok, lsp_config = pcall(require, "mason-lspconfig")
if not config_status_ok then
	return
end

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
	return
end

local servers = {
	"angularls",
	"ansiblels",
	"bashls",
	"clangd",
	"clojure_lsp",
	"cmake",
	"cssls",
	"docker_compose_language_service",
	"dockerls",
	"emmet_ls",
	"eslint",
	"gopls",
	"hls",
	"html",
	"htmx",
	"intelephense",
	"jdtls",
	"jinja_lsp",
	"jsonls",
	"kotlin_language_server",
	"lemminx",
	"ltex",
	"lua_ls",
	"marksman",
	"omnisharp",
	"perlnavigator",
	"phpactor",
	"prismals",
	"pylsp",
	"rubocop",
	"somesass_ls",
	"sqls",
	"stimulus_ls",
	"svelte",
	"tailwindcss",
	"taplo",
	"terraformls",
	"ts_ls",
	"twiggy_language_server",
	"typos_lsp",
	"vimls",
	"vuels",
	"yamlls",
	"zls",
}

java.setup({})

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
	if has_custom_opts then
		opts = vim.tbl_deep_extend("force", opts, server_custom_opts)
	end
	lspconfig[server].setup(opts)
end
