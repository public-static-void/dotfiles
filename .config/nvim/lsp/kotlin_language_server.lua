local utils = require("user.utils")

local handlers = utils.safe_require("user.configs.lsp.handlers")
if not handlers then
	return
end

local filetypes = { "kotlin" }

--- Root markers used to identify the root directory for Kotlin projects.
--- These mark various supported build systems.
local root_markers = {
	"settings.gradle", -- Gradle multi-project
	"settings.gradle.kts", -- Gradle Kotlin DSL multi-project
	"build.xml", -- Ant build
	"pom.xml", -- Maven build
	"build.gradle", -- Gradle single-project
	"build.gradle.kts", -- Gradle Kotlin DSL single-project
	".git",
}

--- Find root directory for Kotlin projects based on root markers.
---@param bufnr number Buffer number
---@param on_dir fun(path: string) Callback to set root directory
local function root_dir(bufnr, on_dir)
	local filepath = vim.api.nvim_buf_get_name(bufnr)
	if not filepath or filepath == "" then
		on_dir(vim.loop.cwd())
		return
	end
	local root = utils.find_root(filepath, root_markers)
	on_dir(root or vim.loop.cwd())
end

local function get_storage_path(bufnr)
	-- Compute storage path based on root dir of current buffer
	local storage_root = nil
	root_dir(bufnr, function(root)
		storage_root = root
	end)
	return storage_root
end

local init_options = {
	storagePath = "", -- to be set dynamically per buffer on attach if needed
}

local on_attach = function(client, bufnr)
	-- Dynamically update storagePath option based on root_dir per buffer
	init_options.storagePath = get_storage_path(bufnr)
	if client.config then
		client.config.init_options = init_options
	end
	if handlers.on_attach then
		handlers.on_attach(client, bufnr)
	end
end

local cmd = { "kotlin-language-server" }

return {
	cmd = cmd,
	filetypes = filetypes,
	root_dir = root_dir,
	on_attach = on_attach,
	capabilities = handlers.capabilities,
	init_options = init_options,
}
