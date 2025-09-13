--- Treesitter-based language enhancements
--- Provides parsing, highlighting, and companion utilities.
--- @type Plugin[]
return {
	{
		"nvim-treesitter/nvim-treesitter",
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
	{
		"HiPhish/rainbow-delimiters.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		event = { "BufReadPost", "BufNewFile" },
		--- Rainbow highlight for nested brackets and delimiters.
	},
}
