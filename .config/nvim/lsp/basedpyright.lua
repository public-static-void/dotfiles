
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
	"pyrightconfig.json",
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

---@param path string Python interpreter or environment path
local function set_python_path(path)
	local clients = vim.lsp.get_clients({
		bufnr = vim.api.nvim_get_current_buf(),
		name = "basedpyright",
	})
	for _, client in ipairs(clients) do
		if client.settings then
			client.settings.python = vim.tbl_deep_extend("force", client.settings.python, { pythonPath = path })
		else
			client.config.settings =
				vim.tbl_deep_extend("force", client.config.settings, { python = { pythonPath = path } })
		end
		client:notify("workspace/didChangeConfiguration", { settings = nil })
	end
end

---@param client table The LSP client
---@param bufnr number The buffer number
local function on_attach(client, bufnr)
	if handlers.on_attach then
		handlers.on_attach(client, bufnr)
	end

	vim.api.nvim_buf_create_user_command(bufnr, "LspBasedPyrightOrganizeImports", function()
		client:exec_cmd({
			command = "basedpyright.organizeimports",
			arguments = { vim.uri_from_bufnr(bufnr) },
		})
	end, {
		desc = "Organize Python imports",
	})

	vim.api.nvim_buf_create_user_command(bufnr, "LspBasedPyrightSetPythonPath", set_python_path, {
		desc = "Set Python interpreter path for BasedPyright",
		nargs = 1,
		complete = "file",
	})
end

local settings = {
	python = {
		analysis = {
			autoSearchPaths = true,
			useLibraryCodeForTypes = true,
			diagnosticMode = "openFilesOnly",
			typeCheckingMode = "off",
			inlayHints = {
				variableTypes = true,
				functionReturnTypes = true,
			},
		},
	},
}

return {
	cmd = { "basedpyright-langserver", "--stdio" },
	filetypes = { "python" },
	root_dir = root_dir,
	on_attach = on_attach,
	capabilities = handlers.capabilities,
	settings = settings,
}
