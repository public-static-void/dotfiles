return {
	-- Markdown
	{
		"iamcco/markdown-preview.nvim",
		ft = { "markdown" },
		build = "cd app && yarn install",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
			vim.g.mkdp_auto_start = 1
			vim.g.mkdp_theme = "light"
		end,
	},
	-- CSV
	{
		"cameron-wags/rainbow_csv.nvim",
		config = function()
			require("rainbow_csv").setup()
		end,
		ft = {
			"csv",
			"tsv",
			"csv_semicolon",
			"csv_whitespace",
			"csv_pipe",
			"rfc_csv",
			"rfc_semicolon",
		},
	},
	-- Blade
	{
		"jwalton512/vim-blade",
		ft = { "blade" },
	},
}
