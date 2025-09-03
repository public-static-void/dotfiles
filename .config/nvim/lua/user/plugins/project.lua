return {
	-- Git
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPost", "BufNewFile" },
	},
	-- Picker
	{
		"ibhagwan/fzf-lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	-- Outline
	{
		"stevearc/aerial.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
	},
	-- Autocreate Directories on Save
	{
		"jghauser/mkdir.nvim",
		event = { "BufWritePre" },
	},
	-- Code Runner
	{
		"CRAG666/code_runner.nvim",
		config = true,
	},
}
