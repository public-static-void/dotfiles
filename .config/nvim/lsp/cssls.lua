local utils = require("user.utils")

local handlers = utils.safe_require("user.lsp.handlers")
if not handlers then
	return
end

--- Root markers to identify project root directory.
local root_markers = { "package.json", ".git" }

--- Determine project root for CSS files by using root markers.
---@param bufnr number
---@param on_dir function Callback with root directory path
local function root_dir(bufnr, on_dir)
	local filepath = vim.api.nvim_buf_get_name(bufnr)
	if not filepath or filepath == "" then
		on_dir(vim.loop.cwd())
		return
	end

	local root = utils.find_root(filepath, root_markers)
	on_dir(root or vim.loop.cwd())
end

local cmd = { "vscode-css-language-server", "--stdio" }
local filetypes = { "css", "scss", "less" }

-- Settings for enabling validation for CSS, SCSS, and Less.
-- 'init_options.provideFormatter' enables formatting capability.
local settings = {
	css = { validate = true },
	scss = { validate = true },
	less = { validate = true },
}

local init_options = {
	provideFormatter = true,
}

return {
	cmd = cmd,
	filetypes = filetypes,
	root_dir = root_dir,
	root_markers = root_markers,
	settings = settings,
	init_options = init_options,
	on_attach = handlers.on_attach,
	capabilities = handlers.capabilities,
}
