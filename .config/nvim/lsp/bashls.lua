local utils = require("user.utils")

local handlers = utils.safe_require("user.configs.lsp.handlers")
if not handlers then
	return
end

local filetypes = {
	"sh",
	"bash",
	"zsh",
}

--- Root markers used to identify root directory of bash projects.
local root_markers = { ".git", ".bashrc" }

--- Determine project root directory for bash scripts.
--- Uses common vcs markers plus bashrc file for home/project roots.
---@param bufnr number Buffer number
---@param on_dir function Callback receiving root directory string
local function root_dir(bufnr, on_dir)
	local filepath = vim.api.nvim_buf_get_name(bufnr)
	if not filepath or filepath == "" then
		on_dir(vim.loop.cwd())
		return
	end

	local root = utils.find_root(filepath, root_markers)
	on_dir(root or vim.loop.cwd())
end

-- Settings to prevent recursive scanning and improve performance.
local settings = {
	bashIde = {
		globPattern = vim.env.GLOB_PATTERN or "*@(.sh|.inc|.bash|.command)",
	},
}

local cmd = { "bash-language-server", "start" }

return {
	cmd = cmd,
	filetypes = filetypes,
	root_dir = root_dir,
	root_markers = root_markers,
	settings = settings,
	on_attach = handlers.on_attach,
	capabilities = handlers.capabilities,
}
