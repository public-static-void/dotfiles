local utils = require("user.utils")

-- Initialize Java setup first
local java = utils.safe_require("java")
if java then
	java.setup({})
end

-- Ensure Mason is available
local mason_ok, mason = pcall(require, "mason")
if not mason_ok then
	vim.notify("mason.nvim not available", vim.log.levels.WARN)
	return
end
mason.setup({})

-- Setup mason-lspconfig
local mason_lsp_ok, mason_lsp = pcall(require, "mason-lspconfig")
if not mason_lsp_ok then
	vim.notify("mason-lspconfig.nvim not available", vim.log.levels.WARN)
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
	-- "typos_lsp",
	"vimls",
	"vuels",
	"yamlls",
	"zls",
}

-- Setup mason-lspconfig
mason_lsp.setup({
	ensure_installed = servers,
})

-- Get common options safely
local handlers_ok, handlers = pcall(require, "user.lsp.handlers")
if not handlers_ok then
	vim.notify("Failed to load LSP handlers", vim.log.levels.ERROR)
	return
end

local common_opts = {
	on_attach = handlers.on_attach,
	capabilities = handlers.capabilities,
}

-- Setup each server with proper error handling
for _, server in ipairs(servers) do
	local server_opts = vim.deepcopy(common_opts) -- Start with fresh copy

	-- Try to load custom settings
	local custom_opts_ok, custom_opts = pcall(require, "user.lsp.settings." .. server)
	if custom_opts_ok and type(custom_opts) == "table" then
		server_opts = vim.tbl_deep_extend("force", server_opts, custom_opts)
	end

	-- Safely setup server
	local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
	if lspconfig_ok and lspconfig[server] then
		local status_ok, err = pcall(lspconfig[server].setup, server_opts)
		if not status_ok then
			vim.notify(string.format("Failed to setup %s: %s", server, err), vim.log.levels.ERROR)
		end
	end
end
