local utils = require("user.utils")

local handlers = utils.safe_require("user.lsp.handlers")
if not handlers then
	return
end

--- Root marker files for Tailwind projects including common config files and .git.
local root_markers = {
	"tailwind.config.ts",
	"tailwind.config.js",
	"tailwind.config.cjs",
	"package.json",
	".git",
}

--- Determine the Tailwind CSS project root directory.
---@param bufnr number Buffer number
---@param on_dir function Callback for root directory path
local function root_dir(bufnr, on_dir)
	local fname = vim.api.nvim_buf_get_name(bufnr)
	if not fname or fname == "" then
		on_dir(vim.loop.cwd())
		return
	end

	-- Combine root markers; extend as needed for your workflow using your utils functions
	local root_files = vim.tbl_extend("force", vim.deepcopy(root_markers), {})
	local root = utils.find_root(fname, root_files)
	on_dir(root or vim.loop.cwd())
end

local cmd = { "tailwindcss-language-server", "--stdio" }

local filetypes = {
	"css",
	"scss",
	"sass",
	"html",
	"heex",
	"javascript",
	"javascriptreact",
	"typescript",
	"typescriptreact",
	"svelte",
	"elixir",
}

-- Tailwind CSS language server settings with linting rules, experimental class regexes and merged includeLanguages table
local settings = {
	tailwindCSS = {
		experimental = {
			classRegex = {
				{ 'class[:=]\\s*"([^"]*)"', 1 },
				{ '~H"([^"]*)"', 1 },
			},
		},
		includeLanguages = {
			elixir = "phoenix-heex",
			eelixir = "html-eex",
			eruby = "erb",
			heex = "phoenix-heex",
			htmlangular = "html",
			templ = "html",
		},
		validate = true,
		lint = {
			cssConflict = "warning",
			invalidApply = "error",
			invalidScreen = "error",
			invalidVariant = "error",
			invalidConfigPath = "error",
			invalidTailwindDirective = "error",
			recommendedVariantOrder = "warning",
		},
		classAttributes = {
			"class",
			"className",
			"class:list",
			"classList",
			"ngClass",
		},
	},
}

---@param _ number
---@param config table
local function before_init(_, config)
	config.settings = config.settings or {}
	config.settings.editor = config.settings.editor or {}
	if not config.settings.editor.tabSize then
		config.settings.editor.tabSize = vim.lsp.util.get_effective_tabstop()
	end
end

return {
	cmd = cmd,
	filetypes = filetypes,
	root_dir = root_dir,
	root_markers = root_markers,
	settings = settings,
	before_init = before_init,
	workspace_required = true,
	on_attach = handlers.on_attach,
	capabilities = handlers.capabilities,
}
