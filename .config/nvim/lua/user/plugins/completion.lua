return {
	-- Core Completion
	{
		"hrsh7th/nvim-cmp",
		event = { "InsertEnter", "CmdlineEnter" },
		dependencies = {
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lua",
			"f3fora/cmp-spell",
			{
				"rcarriga/cmp-dap",
				ft = { "dap-repl", "dapui_watches", "dapui_hover" },
			},
		},
	},
	-- Codeium
	{
		"Exafunction/codeium.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"hrsh7th/nvim-cmp",
		},
		config = function()
			vim.schedule(function()
				require("codeium").setup({
					enable_chat = true,
					enable_cmp = true,
					config_path = vim.fn.stdpath("data") .. "/codeium/config.json",
				})
			end)
		end,
		event = "VeryLazy",
	},
	-- Snippet Engine
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",
		build = "make install_jsregexp",
		dependencies = { "rafamadriz/friendly-snippets" },
		config = function()
			require("luasnip.loaders.from_vscode").lazy_load()
			require("luasnip").filetype_extend("blade", { "html" })
		end,
		event = "InsertEnter",
	},
}
