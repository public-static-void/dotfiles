local utils = require("user.utils")

local null_ls = utils.safe_require("null-ls")
if not null_ls then
	return
end

-- Setup Null-LS with formatting and diagnostics sources
null_ls.setup({
	debug = false,
	sources = {
		-- Diagnostics
		-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
		null_ls.builtins.diagnostics.stylelint,
		null_ls.builtins.diagnostics.gitlint,
		null_ls.builtins.diagnostics.codespell,
		null_ls.builtins.diagnostics.markuplint,
		null_ls.builtins.diagnostics.djlint,
		null_ls.builtins.diagnostics.mypy,

		-- Formatting
		-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
		null_ls.builtins.formatting.djlint,
		null_ls.builtins.formatting.google_java_format,
		null_ls.builtins.formatting.prettier,
		null_ls.builtins.formatting.ktlint,
		null_ls.builtins.formatting.blade_formatter,
		null_ls.builtins.formatting.pint,
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.isort,
		null_ls.builtins.formatting.shfmt,
		null_ls.builtins.formatting.sql_formatter,
		null_ls.builtins.formatting.black.with({
			extra_args = {
				"--preview",
				"--line-length=79",
				"--enable-unstable-feature=string_processing",
				"--enable-unstable-feature=multiline_string_handling",
			},
		}),
	},
})
