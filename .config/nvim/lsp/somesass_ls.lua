local utils = require("user.utils")

local handlers = utils.safe_require("user.configs.lsp.handlers")
if not handlers then
	return
end

local filetypes = {
	"scss",
	"sass",
}

-- Root markers used for Sass/SCSS projects.
local root_markers = { ".git", "package.json" }

--- Determine the root directory for Sass/SCSS files.
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

-- Default settings for some-sass-language-server
local settings = {
	somesass = {
		suggestAllFromOpenDocument = true,
	},
}

local cmd = { "some-sass-language-server", "--stdio" }

return {
	cmd = cmd,
	filetypes = filetypes,
	root_dir = root_dir,
	on_attach = handlers.on_attach,
	capabilities = handlers.capabilities,
	settings = settings,
	single_file_support = true,
}
