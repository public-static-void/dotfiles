local utils = require("user.utils")

local handlers = utils.safe_require("user.configs.lsp.handlers")
if not handlers then
	return
end

local filetypes = { "perl" }

-- Root markers used to detect project root for Perl projects.
local root_markers = { ".git" }

--- Determine the root directory for Perl files.
---@param bufnr number Buffer number
---@param on_dir fun(path: string) Callback with root directory path
local function root_dir(bufnr, on_dir)
	local filepath = vim.api.nvim_buf_get_name(bufnr)
	if not filepath or filepath == "" then
		on_dir(vim.loop.cwd())
		return
	end
	local root = utils.find_root(filepath, root_markers)
	on_dir(root or vim.loop.cwd())
end

-- Default settings for PerlNavigator, can be extended per project.
local settings = {
	perlnavigator = {},
}

local cmd = { "perlnavigator" }

return {
	cmd = cmd,
	filetypes = filetypes,
	root_dir = root_dir,
	on_attach = handlers.on_attach,
	capabilities = handlers.capabilities,
	settings = settings,
	single_file_support = true,
}
