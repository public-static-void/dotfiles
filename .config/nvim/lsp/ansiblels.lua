local utils = require("user.utils")

local handlers = utils.safe_require("user.lsp.handlers")
if not handlers then
	return
end

--- Root markers for Ansible projects.
local root_markers = { "ansible.cfg", ".ansible-lint", ".git" }

--- Resolve project root by finding one of the root markers.
---@param bufnr number Buffer number
---@param on_dir fun(path: string) Callback with resolved root path
local function root_dir(bufnr, on_dir)
	local filepath = vim.api.nvim_buf_get_name(bufnr)
	if not filepath or filepath == "" then
		on_dir(vim.loop.cwd())
		return
	end
	local root = utils.find_root(filepath, root_markers)
	on_dir(root or vim.loop.cwd())
end

-- Language server settings as recommended by official source
local settings = {
	ansible = {
		python = {
			interpreterPath = "python",
		},
		ansible = {
			path = "ansible",
		},
		executionEnvironment = {
			enabled = false,
		},
		validation = {
			enabled = true,
			lint = {
				enabled = true,
				path = "ansible-lint",
			},
		},
	},
}

return {
	cmd = { "ansible-language-server", "--stdio" },
	filetypes = { "yaml.ansible", "ansible" },
	root_markers = root_markers,
	root_dir = root_dir,
	settings = settings,
	on_attach = handlers.on_attach,
	capabilities = handlers.capabilities,
}
