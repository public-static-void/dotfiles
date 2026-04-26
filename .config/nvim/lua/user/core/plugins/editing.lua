--- Editing enhancements and textobject utilities
--- Includes docs generation, autopairs, surround, and navigation.
--- @type table
return {
	{
		--- Dependency for hardtime.nvim.
		src = "https://github.com/MunifTanjim/nui.nvim",
	},
	{
		--- Discourages inefficient habits while also suggesting improvements.
		src = "https://github.com/m4xshen/hardtime.nvim",
	},
	{
		--- Code documentation generation based on Treesitter context.
		src = "https://github.com/danymat/neogen",
	},
	{
		--- Displays CSS colors inline as background blocks for readability.
		src = "https://github.com/brenoprata10/nvim-highlight-colors",
	},
	{
		--- Allows deleting buffers without closing windows.
		src = "https://github.com/famiu/bufdelete.nvim",
	},
	{
		--- Enhance `a`/`i` textobjects with semantic awareness.
		src = "https://github.com/nvim-mini/mini.ai",
		version = vim.version.range("*"),
	},
	{
		--- Highlights word under cursor across buffer, useful for context scanning.
		src = "https://github.com/nvim-mini/mini.cursorword",
		version = vim.version.range("*"),
	},
	{
		--- Autopair brackets and quotes seamlessly.
		src = "https://github.com/nvim-mini/mini.pairs",
		version = vim.version.range("*"),
	},
	{
		--- Add, replace, or delete surrounding pairs (quotes, tags, etc.).
		src = "https://github.com/nvim-mini/mini.surround",
		version = vim.version.range("*"),
	},
	{
		--- Fast motions using syntax-aware jumping.
		src = "https://github.com/folke/flash.nvim",
	},
	{
		--- Core Treesitter plugin for highlighting and parsing.
		src = "https://github.com/nvim-treesitter/nvim-treesitter",
	},
	{
		--- Context-aware `commentstring` adjustment for mixed syntaxes.
		src = "https://github.com/JoosepAlviste/nvim-ts-context-commentstring",
	},
	{
		--- Auto-close and rename HTML/JSX tags.
		src = "https://github.com/windwp/nvim-ts-autotag",
	},
}
