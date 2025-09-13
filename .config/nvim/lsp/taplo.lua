local utils = require("user.utils")

local handlers = utils.safe_require("user.configs.lsp.handlers")
if not handlers then
	return
end

local filetypes = { "toml" }

--- Root marker files for Taplo TOML projects, including common Taplo config files and VCS markers.
local root_markers = { ".taplo.toml", "taplo.toml", "Cargo.toml", "package.json", ".git" }

--- Root directory detection for Taplo based on root markers.
--- Provides taplo with proper workspace context even outside git repos.
---@param bufnr number Buffer number
---@param on_dir function Callback which will be called with root directory path
local function root_dir(bufnr, on_dir)
	local filepath = vim.api.nvim_buf_get_name(bufnr)
	if not filepath or filepath == "" then
		on_dir(vim.loop.cwd())
		return
	end

	local root = utils.find_root(filepath, root_markers)
	on_dir(root or vim.loop.cwd())
end

local cmd = { "taplo", "lsp", "stdio" }

return {
	cmd = cmd,
	filetypes = filetypes,
	root_dir = root_dir,
	root_markers = root_markers,
	on_attach = handlers.on_attach,
	capabilities = handlers.capabilities,
}
