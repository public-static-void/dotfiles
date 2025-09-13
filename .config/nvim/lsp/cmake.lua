local utils = require("user.utils")

local handlers = utils.safe_require("user.configs.lsp.handlers")
if not handlers then
	return
end

local filetypes = { "cmake" }

--- Root markers for project detection
local root_markers = { "CMakePresets.json", "CTestConfig.cmake", "CMakeLists.txt", "build", ".git" }

--- Find root directory for CMake projects.
---@param bufnr number Buffer number
---@param on_dir fun(path: string) Callback to set root directory path
local function root_dir(bufnr, on_dir)
	local filepath = vim.api.nvim_buf_get_name(bufnr)
	if not filepath or filepath == "" then
		on_dir(vim.loop.cwd())
		return
	end
	local root = utils.find_root(filepath, root_markers)
	on_dir(root or vim.loop.cwd())
end

local init_options = {
	buildDirectory = "build",
}

local cmd = { "cmake-language-server" }

local config = {
	cmd = cmd,
	filetypes = filetypes,
	root_dir = root_dir,
	on_attach = handlers.on_attach,
	capabilities = handlers.capabilities,
	init_options = init_options,
	single_file_support = true,
}

return config
