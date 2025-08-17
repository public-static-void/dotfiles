local utils = require("user.utils")

local handlers = utils.safe_require("user.lsp.handlers")
if not handlers then
	return
end

return {
	on_attach = handlers.on_attach,
	capabilities = handlers.capabilities,
	cmd = { "tailwindcss-language-server", "--stdio" },
	filetypes = {
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
	},
	root_markers = {
		"tailwind.config.ts",
		"tailwind.config.js",
		"tailwind.config.cjs",
		"package.json",
		".git",
	},
	settings = {
		tailwindCSS = {
			experimental = {
				classRegex = {
					{ 'class[:=]\\s*"([^"]*)"', 1 },
					{ '~H"([^"]*)"', 1 },
				},
			},
			includeLanguages = {
				elixir = "html-eex",
				heex = "html-eex",
			},
		},
	},
}
