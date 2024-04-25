local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
	return
end

local mason_null_ls_status_ok, mason_null_ls = pcall(require, "mason-null-ls")
if not mason_null_ls_status_ok then
	return
end

local servers = {
	"autopep8",
	"beautysh",
	"black",
	"codespell",
	"djlint",
	"gitlint",
	"google_java_format",
	"isort",
	"markuplint",
	"prettier",
	"stylelint",
	"stylua",
	"vint",
	"vulture",
}

mason_null_ls.setup({
	ensure_installed = servers,
})

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics

null_ls.setup({
	debug = false,
	sources = {
		-- css
		diagnostics.stylelint,
		-- git commit
		diagnostics.gitlint,
		-- general
		diagnostics.codespell,
		-- html, xml
		diagnostics.markuplint,
		-- htmldjango
		diagnostics.djlint,
		formatting.djlint,
		-- java
		formatting.google_java_format,
		-- js
		formatting.prettier,
		-- lua
		formatting.stylua,
		-- python
		-- diagnostics.mypy,
		diagnostics.pylint.with({ extra_args = { "--max-line-length=79" } }),
		diagnostics.vulture,
		formatting.autopep8.with({ extra_args = { "--max_line_length=79" } }),
		formatting.black.with({
			extra_args = {
				"--preview",
				"--line-length=79",
				"--enable-unstable-feature=string_processing",
				"--enable-unstable-feature=multiline_string_handling",
			},
		}),
		-- sh
		formatting.beautysh.with({ extra_args = {
			"--indent-size=2",
		} }),
		formatting.isort,
		-- vimscript
		diagnostics.vint,
	},
})
