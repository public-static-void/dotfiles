local utils = require("user.utils")

local handlers = utils.safe_require("user.lsp.handlers")
if not handlers then
	return
end

return {
	on_attach = handlers.on_attach,
	capabilities = handlers.capabilities,
	filetypes = {
		"bib",
		"context",
		"gitcommit",
		-- "html",
		"mail",
		"markdown",
		"org",
		"pandoc",
		"plaintex",
		"quarto",
		"rmd",
		"rnoweb",
		"rst",
		"tex",
		"text",
		-- "xhtml",
	},
	settings = {
		ltex = {
			-- language = "de-DE",
			language = "en-US",
		},
	},
}
