local utils = require("user.utils")

local handlers = utils.safe_require("user.configs.lsp.handlers")
if not handlers then
	return
end

-- Filetypes handled by the Angular LSP
local filetypes = {
	"typescript",
	"html",
	"typescriptreact",
	"htmlangular",
}

-- Root markers for Angular projects
local root_markers = {
	"angular.json",
	"nx.json",
	"package.json",
	"tsconfig.json",
	".git",
}

--- Determine the project root directory by searching for root markers.
---@param bufnr number Buffer number
---@param on_dir fun(path: string) Callback invoked with resolved root directory
local function root_dir(bufnr, on_dir)
	local filepath = vim.api.nvim_buf_get_name(bufnr)
	if not filepath or filepath == "" then
		on_dir(vim.loop.cwd())
		return
	end
	local root = utils.find_root(filepath, root_markers)
	on_dir(root or vim.loop.cwd())
end

--- Find the nearest 'node_modules' directory starting from a given path, going upward.
---@param path string Path to start searching from
---@return string Path to node_modules or empty string if not found
local function find_node_modules_dir(path)
	local results = vim.fs.find("node_modules", { path = path, upward = true, limit = 1 })
	return results and results[1] or ""
end

--- Build probe locations for TypeScript and Angular language service modules for ngserver.
---@param root string The project root directory
---@return string, string Paths for TS probe and Angular probe directories
local function build_probe_dirs(root)
	if not root or root == "" then
		return "", ""
	end
	local node_modules_dir = find_node_modules_dir(root)
	if node_modules_dir == "" then
		return "", ""
	end
	local ts_probe_dir = node_modules_dir
	local ng_probe_dir = node_modules_dir .. "/@angular/language-server/node_modules"
	return ts_probe_dir, ng_probe_dir
end

local cmd = (function()
	local cwd = vim.loop.cwd()
	local ts_probe, ng_probe = build_probe_dirs(cwd)
	return {
		"ngserver",
		"--stdio",
		"--tsProbeLocations",
		ts_probe,
		"--ngProbeLocations",
		ng_probe,
	}
end)()

return {
	cmd = cmd,
	filetypes = filetypes,
	root_markers = root_markers,
	root_dir = root_dir,
	on_attach = handlers.on_attach,
	capabilities = handlers.capabilities,
}
