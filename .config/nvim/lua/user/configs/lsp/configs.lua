local utils = require("user.utils")

local handlers = utils.safe_require("user.configs.lsp.handlers")
if not handlers then
	return
end

local mason = utils.safe_require("mason")
if not mason then
	vim.notify("mason.nvim not available", vim.log.levels.WARN)
	return
end
mason.setup({})

local servers = {
	"angularls",
	"ansiblels",
	-- "basedpyright",
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
	"laravel_ls",
	"lemminx",
	"ltex-ls-plus",
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
	"twiggy_language_server",
	-- "typos_lsp",
	"vimls",
	"vtsls",
	"vuels",
	"yamlls",
	"zls",
}

local formatters = {
	"beautysh",
	"black",
	"blade-formatter",
	"clang-format",
	"cljfmt",
	"csharpier",
	"gersemi",
	"gofumpt",
	"goimports",
	"golines",
	"google-java-format",
	"isort",
	"ktlint",
	"latexindent",
	"ormolu",
	"php-cs-fixer",
	"pint",
	"prettier",
	"prettierd",
	"shfmt",
	"sql-formatter",
	"stylua",
	"terraform",
	"tex-fmt",
	"xmlformatter",
}

local linters = {
	"ansible-lint",
	"codespell",
	"djlint",
	"gitlint",
	"jsonlint",
	"markuplint",
	"mypy",
	"shellcheck",
	"stylelint",
	"yamllint",
}

local debuggers = {
	"codelldb",
	"delve",
	"java-debug-adapter",
	"java-test",
	"js",
	"local-lua-debugger-vscode",
	"php",
	"python",
}

local mason_tool_installer = utils.safe_require("mason-tool-installer")
if not mason_tool_installer then
	vim.notify("mason-tool-installer.nvim not available", vim.log.levels.WARN)
	return
end

local ensure_installed = {}
vim.list_extend(ensure_installed, servers)
vim.list_extend(ensure_installed, linters)
vim.list_extend(ensure_installed, formatters)
vim.list_extend(ensure_installed, debuggers)

mason_tool_installer.setup({
	ensure_installed = ensure_installed,
	auto_update = true,
	run_on_start = true,
})

vim.lsp.enable(servers)
