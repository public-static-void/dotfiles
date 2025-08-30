local utils = require("user.utils")

local handlers = utils.safe_require("user.lsp.handlers")
if not handlers then
	return
end

local filetypes = { "php" }

--- Root markers used to detect the PHP project root.
--- Include commonly used files for PHP projects plus phpactor config equivalents.
local root_markers = {
	".git",
	"composer.json",
	".phpactor.json",
	".phpactor.yml",
}

--- Detects the root directory for PHP projects.
--- Relies on existing utility logic for consistency and automated root detection.
---@param bufnr number Buffer number
---@param on_dir function Callback that receives the root path as a string
local function root_dir(bufnr, on_dir)
	local filepath = vim.api.nvim_buf_get_name(bufnr)
	if not filepath or filepath == "" then
		on_dir(vim.loop.cwd())
		return
	end

	local root = utils.find_root(filepath, root_markers)
	on_dir(root or vim.loop.cwd())
end

-- Important settings to reduce noise from undefined diagnostics except undefined variables.
local settings = {
	intelephense = {
		diagnostics = {
			undefinedTypes = false,
			undefinedFunctions = false,
			undefinedConstants = false,
			undefinedClassConstants = false,
			undefinedMethods = false,
			undefinedProperties = false,
			undefinedVariables = true,
		},
	},
}

---@param client table The LSP client
local function on_init(client)
	-- Disable document formatting to avoid conflicts with other formatters/plugins
	client.server_capabilities.documentFormattingProvider = false
end

local cmd = { "intelephense", "--stdio" }

return {
	cmd = cmd,
	filetypes = filetypes,
	root_dir = root_dir,
	root_markers = root_markers,
	settings = settings,
	on_init = on_init,
	on_attach = handlers.on_attach,
	capabilities = handlers.capabilities,
}
