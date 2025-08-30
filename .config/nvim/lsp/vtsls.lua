local utils = require("user.utils")

local handlers = utils.safe_require("user.lsp.handlers")
if not handlers then
	return
end

local filetypes = {
	"javascript",
	"javascriptreact",
	"javascript.jsx",
	"typescript",
	"typescriptreact",
	"typescript.tsx",
}

--- Markers to detect project root for TS/JS
local root_markers = { "tsconfig.json", "package.json", "jsconfig.json", ".git" }

--- Finds the root directory for TS/JS projects
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

local cmd = { "vtsls", "--stdio" }

return {
	cmd = cmd,
	filetypes = filetypes,
	root_dir = root_dir,
	single_file_support = single_file_support,
	on_attach = handlers.on_attach,
	capabilities = handlers.capabilities,
}
