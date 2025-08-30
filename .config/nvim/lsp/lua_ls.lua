local utils = require("user.utils")

local handlers = utils.safe_require("user.lsp.handlers")
if not handlers then
	return
end

local filetypes = { "lua" }

--- Root markers to detect Lua project root directory.
local root_markers = {
	".luarc.json",
	".luarc.jsonc",
	".luacheckrc",
	".stylua.toml",
	"stylua.toml",
	"selene.toml",
	"selene.yml",
	".git",
}

--- Determine the project root directory by checking known config files or
--- fallback to git root.
---@param bufnr number Buffer number
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

local settings = {
	Lua = {
		runtime = {
			version = "LuaJIT",
			path = vim.split(package.path, ";"),
		},
		diagnostics = {
			globals = { "vim", "use" },
		},
		workspace = {
			library = vim.api.nvim_get_runtime_file("", true),
			checkThirdParty = false,
		},
		telemetry = {
			enable = false,
		},
	},
}

local cmd = { "lua-language-server" }

return {
	cmd = cmd,
	filetypes = filetypes,
	root_dir = root_dir,
	root_markers = root_markers,
	settings = settings,
	on_attach = handlers.on_attach,
	capabilities = handlers.capabilities,
}
