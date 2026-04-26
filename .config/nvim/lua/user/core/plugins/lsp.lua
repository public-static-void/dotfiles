--- Language Server Protocol (LSP) tooling setup
--- Uses Mason for installation and integrates format/lint hooks.
--- @type table
return {
	{
		--- Package manager for LSP/DAP/formatter tools.
		src = "https://github.com/williamboman/mason.nvim",
	},
	{
		--- Mason LSP configuration bridge.
		src = "https://github.com/williamboman/mason-lspconfig.nvim",
	},
	{
		--- Auto-installs Mason tools.
		src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	{
		--- Java LSP client, used with Eclipse JDTls backend.
		src = "https://github.com/mfussenegger/nvim-jdtls",
	},
	{
		--- Adds completion + API docs for Neovim Lua.
		src = "https://github.com/folke/lazydev.nvim",
	},
	{
		--- Lightweight formatter integration.
		src = "https://github.com/stevearc/conform.nvim",
	},
	{
		--- Lightweight asynchronous linter integration.
		src = "https://github.com/mfussenegger/nvim-lint",
	},
}
