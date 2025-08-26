local utils = require("user.utils")

local handlers = utils.safe_require("user.lsp.handlers")
if not handlers then
	return
end

--- Root markers used to anchor the project.
--- `.git` is the primary marker; `.vimrc` is included to cover standalone Vim configs.
local root_markers = { ".git", ".vimrc" }

--- Root dir function walks upward to find a recognized marker, else falls back to cwd.
---@param bufnr number Buffer number
---@param on_dir function Callback with resolved root dir
local function root_dir(bufnr, on_dir)
	local filepath = vim.api.nvim_buf_get_name(bufnr)
	if not filepath or filepath == "" then
		on_dir(vim.loop.cwd())
		return
	end
	local root = utils.find_root(filepath, root_markers)
	on_dir(root or vim.loop.cwd())
end

--- Initialization options let the server behave "Neovim-aware" and control indexing.
--- Without these, the server would underutilize runtimepath and fail to suggest from Vim runtime.
local init_options = {
	isNeovim = true, -- ensures server understands `nvim` differences
	iskeyword = "@,48-57,_,192-255,-#", -- better keyword recognition (numbers, unicode, dashes)
	vimruntime = vim.env.VIMRUNTIME or "", -- runtime discovery; fallback if env unset
	runtimepath = vim.o.runtimepath, -- use current runtimepath for suggestions & indexing
	diagnostic = { enable = true }, -- enable basic diagnostics like undefined vars
	indexes = {
		runtimepath = true, -- scan runtimepath for functions/commands
		gap = 100, -- scan rate (performance vs. responsiveness)
		count = 3, -- max files per project checked
		projectRootPatterns = { "runtime", "nvim", ".git", "autoload", "plugin" },
	},
	suggest = {
		fromVimruntime = true, -- builtin functions/commands
		fromRuntimepath = true, -- project-specific runtime files
	},
}

-- Final config passed back to be consumed by vim.lsp.start
return {
	cmd = { "vim-language-server", "--stdio" },
	filetypes = { "vim" },
	root_markers = root_markers,
	root_dir = root_dir,
	on_attach = handlers.on_attach,
	capabilities = handlers.capabilities,
	init_options = init_options,
}
