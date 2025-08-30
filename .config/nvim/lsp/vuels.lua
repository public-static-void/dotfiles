local utils = require("user.utils")

local handlers = utils.safe_require("user.lsp.handlers")
if not handlers then
	return
end

local filetypes = { "vue" }

--- Markers to identify project root
local root_markers = { "package.json", "yarn.lock", "pnpm-lock.yaml", "lerna.json", ".git" }

--- Finds root directory looking for common package and lock files
---@param bufnr number
---@param on_dir function
local function root_dir(bufnr, on_dir)
	local filepath = vim.api.nvim_buf_get_name(bufnr)
	if not filepath or filepath == "" then
		on_dir(vim.loop.cwd())
		return
	end
	local root = utils.find_root(filepath, root_markers)
	on_dir(root or vim.loop.cwd())
end

local single_file_support = true

local init_options = {
	config = {
		vetur = {
			useWorkspaceDependencies = false,
			validation = {
				template = true,
				style = true,
				script = true,
			},
			completion = {
				autoImport = false,
				useScaffoldSnippets = false,
				tagCasing = "kebab",
			},
			format = {
				defaultFormatter = {
					js = "none",
					ts = "none",
				},
				defaultFormatterOptions = {},
				scriptInitialIndent = false,
				styleInitialIndent = false,
			},
		},
		css = {},
		html = {
			suggest = {},
		},
		javascript = {
			format = {},
		},
		typescript = {
			format = {},
		},
		emmet = {},
		stylusSupremacy = {},
	},
}

local cmd = { "vls" }

return {
	cmd = cmd,
	filetypes = filetypes,
	root_dir = root_dir,
	single_file_support = single_file_support,
	init_options = init_options,
	on_attach = handlers.on_attach,
	capabilities = handlers.capabilities,
}
