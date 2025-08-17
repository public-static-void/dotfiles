local utils = require("user.utils")

local handlers = utils.safe_require("user.lsp.handlers")
if not handlers then
	return
end

return {
	on_attach = handlers.on_attach,
	capabilities = handlers.capabilities,
	cmd = { "pylsp" },
	filetypes = { "python" },
	settings = {
		pylsp = {
			plugins = {
				autopep8 = { enabled = false },
				flake8 = {
					enabled = true,
					maxLineLength = 79,
					ignore = { "E203", "E266", "W503", "W504" },
					exclude = { ".git", "**pycache**", ".venv", "old", "build", "dist" },
				},
				jedi_completion = { enabled = true },
				jedi_definition = { enabled = true },
				jedi_hover = { enabled = true },
				jedi_signature_help = { enabled = true },
				jedi_symbols = { enabled = true },
				mccabe = { enabled = false },
				pycodestyle = { enabled = false },
				pydocstyle = { enabled = true },
				pyflakes = { enabled = false },
				pylint = { enabled = true, args = { "--max-line-length=79" } },
				rope_autoimport = { enabled = true },
				rope_completion = { enabled = false },
				yapf = { enabled = false },
			},
		},
	},
}
