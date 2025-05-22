return {
	{
		-- Treesitter
		"nvim-treesitter/nvim-treesitter",
		-- build = ":TSUpdateSync",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
	},
	-- Context Commentstring
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
	},
	-- Autotag
	{
		"windwp/nvim-ts-autotag",
		event = { "BufReadPost", "BufNewFile" },
	},
	-- Rainbow Delimiters
	{
		"HiPhish/rainbow-delimiters.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		event = { "BufReadPost", "BufNewFile" },
	},
}
