local utils = require("user.utils")

local java = utils.safe_require("java")
if not java then
	return
end

local lsp_installer = utils.safe_require("mason")
if not lsp_installer then
	return
end

local lsp_config = utils.safe_require("mason-lspconfig")
if not lsp_config then
	return
end

local lspconfig = utils.safe_require("lspconfig")
if not lspconfig then
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
	-- "ltex",
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
	-- "typos_lsp",
	"vimls",
	"vuels",
	"yamlls",
	"zls",
}

-- Setup Java language server
java.setup({})

-- Setup Mason
lsp_installer.setup({})

-- Ensure specified language servers are installed
lsp_config.setup({
	ensure_installed = servers,
})

-- Common options for all LSP servers
local common_opts = {
	on_attach = require("user.lsp.handlers").on_attach,
	capabilities = require("user.lsp.handlers").capabilities,
}

-- Setup each server with custom options if available
for _, server in ipairs(servers) do
	local opts = vim.tbl_deep_extend("force", {}, common_opts)

	local has_custom_opts, server_custom_opts = pcall(require, "user.lsp.settings." .. server)
	if has_custom_opts then
		opts = vim.tbl_deep_extend("force", opts, server_custom_opts)
	end

	-- Safely setup the server with options
	local setup_status_ok, setup_error = pcall(function()
		lspconfig[server].setup(opts)
	end)

	if not setup_status_ok then
		vim.notify(string.format("Failed to setup %s: %s", server, setup_error), vim.log.levels.ERROR)
	end
end
