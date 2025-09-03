return {
	-- Doc Strings
	{
		"danymat/neogen",
		event = "VeryLazy",
	},
	-- Highlight colors
	{
		"brenoprata10/nvim-highlight-colors",
		event = "VeryLazy",
	},
	-- Enhanced (a)round and (i)nside textobject functionality
	{
		"nvim-mini/mini.ai",
		version = "*",
		config = function()
			require("mini.ai").setup()
		end,
	},
	-- Highlight word under cursor
	{
		"nvim-mini/mini.cursorword",
		version = "*",
	},
	-- Highlight patterns
	{
		"nvim-mini/mini.hipatterns",
		version = "*",
		config = function()
			require("mini.hipatterns").setup()
		end,
	},
	-- Buffer deletion
	{
		"famiu/bufdelete.nvim",
		event = "VeryLazy",
	},
	-- Autopairs
	{
		"nvim-mini/mini.pairs",
		version = "*",
		config = function()
			require("mini.pairs").setup()
		end,
	},
	-- Surround
	{
		"nvim-mini/mini.surround",
		version = "*",
		config = function()
			require("mini.surround").setup()
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
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		---@type Flash.Config
		opts = {},
	},
	-- Remote File Editing via SSH
	{
		"chipsenkbeil/distant.nvim",
		branch = "v0.3",
		config = function()
			require("distant"):setup()
		end,
	},
}
