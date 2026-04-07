--- Editing enhancements and textobject utilities
--- Includes docs generation, autopairs, surround, and navigation.
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
	},
	{
		"famiu/bufdelete.nvim",
		--- Allows deleting buffers without closing windows.
		event = "VeryLazy",
	},
	{
		"nvim-mini/mini.ai",
		version = "*",
		--- Enhance `a`/`i` textobjects with semantic awareness.
	},
	{
		"nvim-mini/mini.cursorword",
		version = "*",
		--- Highlights word under cursor across buffer, useful for context scanning.
	},
	{
		"nvim-mini/mini.pairs",
		version = "*",
		--- Autopair brackets and quotes seamlessly.
	},
	{
		"nvim-mini/mini.surround",
		version = "*",
		--- Add, replace, or delete surrounding pairs (quotes, tags, etc.).
	},
	{
		"m4xshen/hardtime.nvim",
		lazy = false,
		dependencies = { "MunifTanjim/nui.nvim" },
		--- Discourages inefficient habits while also suggesting improvements.
	},
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		--- Fast motions using syntax-aware jumping.
	},
	{
		"nvim-treesitter/nvim-treesitter",
		main = "nvim-treesitter",
		commit = "90cd658",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		--- Core Treesitter plugin for highlighting and parsing.
	},
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		--- Context-aware `commentstring` adjustment for mixed syntaxes.
	},
	{
		"windwp/nvim-ts-autotag",
		event = { "BufReadPost", "BufNewFile" },
		--- Auto-close and rename HTML/JSX tags.
	},
}
