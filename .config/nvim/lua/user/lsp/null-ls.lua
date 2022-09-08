local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
	return
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics

null_ls.setup({
	debug = false,
	sources = {
		-- js
		diagnostics.eslint,
		diagnostics.jshint,
		formatting.prettier,
		-- css
		diagnostics.stylelint,
		-- html
		diagnostics.tidy,
		-- lua
		formatting.stylua,
		-- sh
		diagnostics.shellcheck,
		formatting.shfmt,
		-- java
		formatting.google_java_format,
		-- python
		diagnostics.flake8,
		diagnostics.pylint,
		diagnostics.vulture,
		formatting.isort,
		formatting.black,
		formatting.autopep8,
		-- git commit
		diagnostics.gitlint,
		-- general
		diagnostics.codespell,
	},
})
