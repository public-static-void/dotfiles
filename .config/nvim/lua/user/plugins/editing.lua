return {
	-- Docsstrings
	{
		"danymat/neogen",
		event = "VeryLazy",
	},
	-- Highlight colors
	{
		"brenoprata10/nvim-highlight-colors",
		event = "VeryLazy",
	},
	-- Highlight words
	{
		"RRethy/vim-illuminate",
		event = "VeryLazy",
	},
	-- Buffer deletion
	{
		"famiu/bufdelete.nvim",
		event = "VeryLazy",
	},
	-- Autopairs
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
	},
	-- Surround
	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({})
		end,
	},
	-- Hardtime
	{
		"m4xshen/hardtime.nvim",
		lazy = false,
		dependencies = { "MunifTanjim/nui.nvim" },
		opts = {
			disabled_keys = {
				["<Up>"] = false,
				["<Down>"] = false,
				["<Left>"] = false,
				["<Right>"] = false,
			},
			disable_mouse = false,
		},
	},
	-- UndoTree
	{
		"jiaoshijie/undotree",
		dependencies = "nvim-lua/plenary.nvim",
		config = true,
	},
}
