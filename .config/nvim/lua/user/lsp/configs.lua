local utils = require("user.utils")

-- local java = utils.safe_require("java")
-- if java then
-- 	java.setup({})
-- end

local handlers = utils.safe_require("user.lsp.handlers")
if not handlers then
	return
end

local mason = utils.safe_require("mason")
if not mason then
	vim.notify("mason.nvim not available", vim.log.levels.WARN)
	return
end
mason.setup({})

local mason_lsp = utils.safe_require("mason-lspconfig")
if not mason_lsp then
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
	"rust_analyzer",
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
	automatic_installation = true,
})

vim.lsp.enable(servers)
