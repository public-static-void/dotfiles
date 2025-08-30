return {
	-- Mason
	{
		"williamboman/mason.nvim",
		cmd = { "Mason", "MasonInstall", "MasonUpdate" },
		build = ":MasonUpdate",
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
	},
	-- Java LSP
	{
		"mfussenegger/nvim-jdtls",
	},
	-- Neovim Lua LSP
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	-- Format
	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
	},
	-- Lint
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
	},
}
