local utils = require("user.utils")

local handlers = utils.safe_require("user.lsp.handlers")
if not handlers then
	return
end

--- Root markers recognize both v1 and v2 docker-compose naming conventions.
--- Include fallback to .git so the LSP activates in repos with Compose manifests.
local root_markers = {
	"docker-compose.yaml",
	"docker-compose.yml",
	"compose.yaml",
	"compose.yml",
	".git",
}

--- Root detection walks upwards to locate a valid marker.
---@param bufnr number Buffer handle
---@param on_dir fun(path:string) Callback with resolved root
local function root_dir(bufnr, on_dir)
	local filepath = vim.api.nvim_buf_get_name(bufnr)
	if not filepath or filepath == "" then
		on_dir(vim.loop.cwd())
		return
	end
	local root = utils.find_root(filepath, root_markers)
	on_dir(root or vim.loop.cwd())
end

-- Final Docker Compose LS configuration
return {
	cmd = { "docker-compose-langserver", "--stdio" },
	-- Explicitly use yaml.docker-compose so the server always activates correctly
	filetypes = { "yaml.docker-compose" },
	root_markers = root_markers,
	root_dir = root_dir,
	on_attach = handlers.on_attach,
	capabilities = handlers.capabilities,
}
