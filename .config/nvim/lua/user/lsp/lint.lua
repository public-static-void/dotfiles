local utils = require("user.utils")

local lint = utils.safe_require("lint")
if not lint then
	return
end

lint.linters_by_ft = {
	python = { "mypy" },
	htmldjango = { "djlint" },
	jinja = { "djlint" },
	mustache = { "djlint" },
	twig = { "djlint" },
	handlebars = { "djlint" },
	gitcommit = { "gitlint" },
	css = { "stylelint" },
	sass = { "stylelint" },
	scss = { "stylelint" },
	less = { "stylelint" },
	html = { "markuplint" },
}

local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
	group = lint_augroup,
	callback = function()
		lint.try_lint()
	end,
})
