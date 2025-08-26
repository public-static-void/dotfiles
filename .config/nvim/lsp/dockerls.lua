local utils = require("user.utils")

local handlers = utils.safe_require("user.lsp.handlers")
if not handlers then
	return
end

--- Root markers for Docker projects.
--- Prefer a local Dockerfile if available, else fall back to .git repository root.
local root_markers = { "Dockerfile", ".git" }

--- Resolve project root dynamically by scanning for markers.
---@param bufnr integer Buffer handle
---@param on_dir fun(path:string) Callback invoked with resolved root
local function root_dir(bufnr, on_dir)
	local filepath = vim.api.nvim_buf_get_name(bufnr)
	if not filepath or filepath == "" then
		on_dir(vim.loop.cwd())
		return
	end
	local root = utils.find_root(filepath, root_markers)
	on_dir(root or vim.loop.cwd())
end

--- Custom settings for docker-langserver.
--- The formatter can be configured for multiline instructions; disabling reformat
--- on multiline RUN commands avoids breaking stylistic conventions in Dockerfiles.
local settings = {
	docker = {
		languageserver = {
			formatter = {
				ignoreMultilineInstructions = true,
			},
		},
	},
}

-- Final LSP config for Docker
return {
	cmd = { "docker-langserver", "--stdio" },
	filetypes = { "dockerfile" },
	root_markers = root_markers,
	root_dir = root_dir,
	on_attach = handlers.on_attach,
	capabilities = handlers.capabilities,
	settings = settings,
}
