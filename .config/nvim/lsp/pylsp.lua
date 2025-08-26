local utils = require("user.utils")

local handlers = utils.safe_require("user.lsp.handlers")
if not handlers then
	return
end

local root_markers = {
	"pyproject.toml",
	"setup.py",
	"setup.cfg",
	"requirements.txt",
	"Pipfile",
	".git",
}

---@param bufnr number Buffer number
---@param on_dir function Callback to set root directory
local function root_dir(bufnr, on_dir)
	local filepath = vim.api.nvim_buf_get_name(bufnr)
	if not filepath or filepath == "" then
		on_dir(vim.loop.cwd())
		return
	end

	local root = utils.find_root(filepath, root_markers)
	on_dir(root or vim.loop.cwd())
end

local settings = {
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
}

return {
	cmd = { "pylsp" },
	filetypes = { "python" },
	root_dir = root_dir,
	on_attach = handlers.on_attach,
	capabilities = handlers.capabilities,
	settings = settings,
}
