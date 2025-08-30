local utils = require("user.utils")

local handlers = utils.safe_require("user.lsp.handlers")
if not handlers then
	return
end

local filetypes = { "rust" }

local root_markers = { "Cargo.toml", ".git" }

--- Reloads the Cargo workspace in the Rust analyzer.
--- This requests the LSP server to recompute workspace information.
--- Useful after changing dependencies or workspace settings.
---@param bufnr number Buffer number for which to reload workspace
local function reload_workspace(bufnr)
	local clients = vim.lsp.get_clients({ bufnr = bufnr, name = "rust_analyzer" })
	for _, client in ipairs(clients) do
		vim.notify("Reloading Cargo workspace")
		client:request("rust-analyzer/reloadWorkspace", nil, function(err)
			if err then
				error(tostring(err))
			end
			vim.notify("Cargo workspace reloaded")
		end, bufnr)
	end
end

--- Identifies the project root directory for Rust projects.
--- Looks for Cargo.toml or .git files upward from the current buffer path.
--- Falls back to the current working directory if no root marker found.
---@param bufnr number The buffer number to find root for
---@param on_dir function Callback function called with root directory path
local function root_dir(bufnr, on_dir)
	local filepath = vim.api.nvim_buf_get_name(bufnr)
	if not filepath or filepath == "" then
		on_dir(vim.loop.cwd())
		return
	end

	local root = utils.find_root(filepath, { "Cargo.toml", ".git" })
	on_dir(root or vim.loop.cwd())
end

--- Runs when rust-analyzer attaches to a buffer.
--- Registers buffer-local user commands for ease of cargo workspace reload.
---@param client table The LSP client object
---@param bufnr number The buffer number
local function on_attach(client, bufnr)
	if handlers.on_attach then
		handlers.on_attach(client, bufnr)
	end

	vim.api.nvim_buf_create_user_command(bufnr, "LspCargoReload", function()
		reload_workspace(bufnr)
	end, {
		desc = "Reload the current Cargo workspace",
	})
end

--- Settings table exposing rust-analyzer specific config options.
--- Add or customize settings as needed per project or global preferences.
local rust_analyzer_settings = {
	-- ["rust-analyzer"] = {
	--   diagnostics = { enable = true },
	--   checkOnSave = { command = "clippy" },
	-- },
}

--- Additional rust-analyzer capabilities, such as server status notifications.
local experimental_capabilities = {
	experimental = {
		serverStatusNotification = true,
	},
}

local before_init = function(init_params, config)
	if config.settings and config.settings["rust-analyzer"] then
		init_params.initializationOptions = config.settings["rust-analyzer"]
	end
end

local capabilities = vim.tbl_deep_extend("force", handlers.capabilities or {}, experimental_capabilities)

local cmd = { "rust-analyzer" }

return {
	cmd = cmd,
	filetypes = filetypes,
	root_dir = root_dir,
	on_attach = on_attach,
	capabilities = capabilities,
	settings = rust_analyzer_settings,
	root_markers = root_markers,
}
