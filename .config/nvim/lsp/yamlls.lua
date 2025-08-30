local utils = require("user.utils")

local handlers = utils.safe_require("user.lsp.handlers")
if not handlers then
	return
end

local filetypes = {
	"yaml",
	"yml",
	"yaml.docker-compose",
	"yaml.gitlab",
	"yaml.helm-values",
}

--- Root markers used to detect YAML project root.
local root_markers = { ".git" }

--- Detects the project root directory via root markers.
---@param bufnr number Buffer number
---@param on_dir function Callback receives root directory path as string
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
	-- Disable Red Hat telemetry for privacy and performance
	redhat = { telemetry = { enabled = false } },
	-- Enable YAML formatting support
	yaml = {
		format = { enable = true },
	},
}

---@param client table The LSP client instance
local function on_init(client)
	-- yaml-language-server disables formatting by default, forcibly enable it here
	client.server_capabilities.documentFormattingProvider = true
end

local cmd = { "yaml-language-server", "--stdio" }

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
