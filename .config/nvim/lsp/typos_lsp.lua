local utils = require("user.utils")

local handlers = utils.safe_require("user.lsp.handlers")
if not handlers then
	return
end

local filetypes = {
	"markdown",
	"text",
	"gitcommit",
	"latex",
	"org",
	"vim",
	"python",
}

--- Root markers to anchor typos-lsp per project.
--- Order matters: project-specific config takes precedence if present.
local root_markers = {
	"typos.toml", -- standard config filename (local)
	"_typos.toml", -- alternate config filename
	".typos.toml", -- hidden file variant
	"pyproject.toml", -- common in Python projects
	"Cargo.toml", -- common in Rust projects
	".git", -- fallback: root of Git repo
}

-- Config path resolution: use local typos.toml if present, otherwise fallback
-- to the config file shipped with the Neovim config. This allows project-level
-- customization while still providing a global fallback.
local sep = package.config:sub(1, 1)
local global_config = vim.fn.stdpath("config") .. sep .. "lsp" .. sep .. "typos.toml"

--- Determine project root by scanning upward for known markers.
---@param bufnr number Buffer number whose file to analyze
---@param on_dir function Callback with resolved root directory
local function root_dir(bufnr, on_dir)
	local filepath = vim.api.nvim_buf_get_name(bufnr)
	if not filepath or filepath == "" then
		on_dir(vim.loop.cwd())
		return
	end

	local root = utils.find_root(filepath, root_markers)
	on_dir(root or vim.loop.cwd())
end

-- Initialization options control severity and config source
local init_options = {
	-- Default to warnings to ensure spell diagnostics are noticeable but not blocking
	diagnosticSeverity = "Warning",

	-- Fallback config path ensures typos-lsp works even without project config
	config = global_config,
}

local cmd = { "typos-lsp" }

return {
	cmd = cmd,
	filetypes = filetypes,
	root_dir = root_dir,
	root_markers = root_markers,
	on_attach = handlers.on_attach,
	capabilities = handlers.capabilities,
	init_options = init_options,
}
