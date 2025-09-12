local utils = require("user.utils")

local lint = utils.safe_require("lint")
if not lint then
	return
end

lint.linters_by_ft = {
	ansible = { "ansible_lint" },
	bash = { "shellcheck", "codespell" },
	c = { "codespell" },
	cpp = { "codespell" },
	css = { "stylelint", "codespell" },
	gitcommit = { "gitlint" },
	go = { "codespell" },
	handlebars = { "djlint" },
	html = { "markuplint" },
	htmldjango = { "djlint" },
	java = { "codespell" },
	javascript = { "codespell" },
	jinja = { "djlint" },
	json = { "jsonlint" },
	less = { "stylelint", "codespell" },
	lua = { "codespell" },
	markup = { "markuplint" },
	mustache = { "djlint" },
	php = { "codespell" },
	python = { "mypy", "codespell" },
	rust = { "codespell" },
	sass = { "stylelint", "codespell" },
	scss = { "stylelint", "codespell" },
	sh = { "shellcheck", "codespell" },
	twig = { "djlint", "codespell" },
	typescript = { "codespell" },
	yaml = { "yamllint" },
}

local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
	group = lint_augroup,
	callback = function()
		lint.try_lint()
	end,
})
