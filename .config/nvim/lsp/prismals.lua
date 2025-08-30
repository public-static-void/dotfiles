local utils = require("user.utils")

local handlers = utils.safe_require("user.lsp.handlers")
if not handlers then
	return
end

local filetypes = { "prisma" }

--- Root markers to identify project root directory
local root_markers = { ".git" }

--- Finds the root directory of the current project
---@param bufnr number
---@param on_dir function
local function root_dir(bufnr, on_dir)
	local filepath = vim.api.nvim_buf_get_name(bufnr)
	if not filepath or filepath == "" then
		on_dir(vim.loop.cwd())
		return
	end
	local root = utils.find_root(filepath, root_markers)
	on_dir(root or vim.loop.cwd())
end

local single_file_support = true

--- Settings for prisma-language-server (empty for now, extend if needed)
local settings = {
	prisma = {
		prismaFmtBinPath = "",
	},
}

local cmd = { "prisma-language-server", "--stdio" }

return {
	cmd = cmd,
	filetypes = filetypes,
	root_dir = root_dir,
	single_file_support = single_file_support,
	settings = settings,
	on_attach = handlers.on_attach,
	capabilities = handlers.capabilities,
}
