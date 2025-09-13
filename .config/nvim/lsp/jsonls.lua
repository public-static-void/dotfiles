local utils = require("user.utils")

local handlers = utils.safe_require("user.configs.lsp.handlers")
if not handlers then
	return
end

local filetypes = {
	"json",
	"jsonc",
}

local root_markers = { ".git" }

--- Predefined JSON schemas for common config files.
--- This avoids needing external plugins like SchemaStore.nvim.
local schemas = {
	{
		description = "TypeScript compiler configuration file",
		fileMatch = { "tsconfig.json", "tsconfig.*.json" },
		url = "https://json.schemastore.org/tsconfig.json",
	},
	{
		description = "Lerna config",
		fileMatch = { "lerna.json" },
		url = "https://json.schemastore.org/lerna.json",
	},
	{
		description = "Babel configuration",
		fileMatch = { ".babelrc.json", ".babelrc", "babel.config.json" },
		url = "https://json.schemastore.org/babelrc.json",
	},
	{
		description = "ESLint config",
		fileMatch = { ".eslintrc.json", ".eslintrc" },
		url = "https://json.schemastore.org/eslintrc.json",
	},
	{
		description = "Bucklescript config",
		fileMatch = { "bsconfig.json" },
		url = "https://raw.githubusercontent.com/rescript-lang/rescript-compiler/8.2.0/docs/docson/build-schema.json",
	},
	{
		description = "Prettier config",
		fileMatch = { ".prettierrc", ".prettierrc.json", "prettier.config.json" },
		url = "https://json.schemastore.org/prettierrc",
	},
	{
		description = "Vercel Now config",
		fileMatch = { "now.json" },
		url = "https://json.schemastore.org/now",
	},
	{
		description = "Stylelint config",
		fileMatch = { ".stylelintrc", ".stylelintrc.json", "stylelint.config.json" },
		url = "https://json.schemastore.org/stylelintrc",
	},
	{
		description = "ASP.NET LaunchSettings.json",
		fileMatch = { "launchsettings.json" },
		url = "https://json.schemastore.org/launchsettings.json",
	},
	{
		description = "CMake Presets",
		fileMatch = { "CMakePresets.json", "CMakeUserPresets.json" },
		url = "https://raw.githubusercontent.com/Kitware/CMake/master/Help/manual/presets/schema.json",
	},
	{
		description = "Code Climate config",
		fileMatch = { ".codeclimate.json" },
		url = "https://json.schemastore.org/codeclimate.json",
	},
	{
		description = "LLVM compile_commands.json",
		fileMatch = { "compile_commands.json" },
		url = "https://json.schemastore.org/compile-commands.json",
	},
	{
		description = "Command Task Runner",
		fileMatch = { "commands.json" },
		url = "https://json.schemastore.org/commands.json",
	},
	{
		description = "AWS CloudFormation",
		fileMatch = { "*.cf.json", "cloudformation.json" },
		url = "https://raw.githubusercontent.com/awslabs/goformation/v5.2.9/schema/cloudformation.schema.json",
	},
	{
		description = "AWS SAM",
		fileMatch = { "serverless.template", "*.sam.json", "sam.json" },
		url = "https://raw.githubusercontent.com/awslabs/goformation/v5.2.9/schema/sam.schema.json",
	},
	{
		description = "GitHub Workflow template properties",
		fileMatch = { ".github/workflow-templates/**/*.properties.json" },
		url = "https://json.schemastore.org/github-workflow-template-properties.json",
	},
	{
		description = "golangci-lint config",
		fileMatch = { ".golangci.toml", ".golangci.json" },
		url = "https://json.schemastore.org/golangci-lint.json",
	},
	{
		description = "JSON Feed format",
		fileMatch = { "feed.json" },
		url = "https://json.schemastore.org/feed.json",
		versions = {
			["1"] = "https://json.schemastore.org/feed-1.json",
			["1.1"] = "https://json.schemastore.org/feed.json",
		},
	},
	{
		description = "Packer template",
		fileMatch = { "packer.json" },
		url = "https://json.schemastore.org/packer.json",
	},
	{
		description = "NPM package.json",
		fileMatch = { "package.json" },
		url = "https://json.schemastore.org/package.json",
	},
	{
		description = "VS component config",
		fileMatch = { "*.vsconfig" },
		url = "https://json.schemastore.org/vsconfig.json",
	},
	{
		description = "Resume schema",
		fileMatch = { "resume.json" },
		url = "https://raw.githubusercontent.com/jsonresume/resume-schema/v1.0.0/schema.json",
	},
}

-- Enable schema-based validation and completions
local settings = {
	json = {
		schemas = schemas,
		validate = { enable = true },
	},
}

-- Init options give server control over formatting
local init_options = {
	provideFormatter = true,
}

local cmd = { "vscode-json-language-server", "--stdio" }

-- Final config for JSON language server
return {
	cmd = cmd,
	filetypes = filetypes,
	root_markers = root_markers,
	on_attach = handlers.on_attach,
	capabilities = handlers.capabilities,
	init_options = init_options,
	settings = settings,
}
