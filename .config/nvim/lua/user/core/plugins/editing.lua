--- Editing enhancements and textobject utilities
--- Includes docs generation, autopairs, surround, undo history, and navigation.
--- @type Plugin[]
return {
	{
		"danymat/neogen",
		--- Code documentation generation based on treesitter context.
		event = "VeryLazy",
	},
	{
		"brenoprata10/nvim-highlight-colors",
		--- Displays CSS colors inline as background blocks for readability.
		event = "VeryLazy",
		opts = {},
	},
	{
		"nvim-mini/mini.ai",
		version = "*",
		--- Enhance `a`/`i` textobjects with semantic awareness.
		config = function()
			require("mini.ai").setup()
		end,
	},
	{
		"nvim-mini/mini.cursorword",
		version = "*",
		--- Highlights word under cursor across buffer, useful for context scanning.
	},
	{
		"famiu/bufdelete.nvim",
		--- Allows deleting buffers without closing windows.
		event = "VeryLazy",
	},
	{
		"nvim-mini/mini.pairs",
		version = "*",
		--- Autopair brackets and quotes seamlessly.
		config = function()
			require("mini.pairs").setup()
		end,
	},
	{
		"nvim-mini/mini.surround",
		version = "*",
		--- Add, replace, or delete surrounding pairs (quotes, tags, etc.).
		config = function()
			require("mini.surround").setup()
		end,
	},
	{
		"m4xshen/hardtime.nvim",
		lazy = false,
		dependencies = { "MunifTanjim/nui.nvim" },
		--- Discourages inefficient habits while also suggesting improvements.
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
	{
		"jiaoshijie/undotree",
		dependencies = "nvim-lua/plenary.nvim",
		config = true,
		--- Provides a tree-like history of undos for branching timelines.
	},
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		--- Fast motions using syntax-aware jumping.
		--- @type Flash.Config
		opts = {},
	},
}
