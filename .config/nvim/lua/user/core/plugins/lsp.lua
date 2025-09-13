--- Language Server Protocol (LSP) tooling setup
--- Uses Mason for installation and integrates format/lint hooks.
--- @type Plugin[]
return {
	{
		"williamboman/mason.nvim",
		cmd = { "Mason", "MasonInstall", "MasonUpdate" },
		build = ":MasonUpdate",
		--- Package manager for LSP/DAP/formatter tools.
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
	},
	{
		"mfussenegger/nvim-jdtls",
		--- Java LSP client, used with Eclipse JDTls backend.
	},
	{
		"folke/lazydev.nvim",
		ft = "lua",
		--- Adds completion + API docs for Neovim Lua.
	},
	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		--- Lightweight formatter integration.
	},
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		--- Lightweight asynchronous linter integration.
	},
}
