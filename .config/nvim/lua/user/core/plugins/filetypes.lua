--- Filetype-specific enhancements
--- @type Plugin[]
return {
	{
		"iamcco/markdown-preview.nvim",
		ft = { "markdown" },
		build = "cd app && yarn install",
		--- Opens an external live preview for Markdown documents in browser.
		--- Configured to start automatically on buffer load.
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
			vim.g.mkdp_auto_start = 0
			vim.g.mkdp_theme = "light"
		end,
	},
	{
		"cameron-wags/rainbow_csv.nvim",
		ft = {
			"csv",
			"tsv",
			"csv_semicolon",
			"csv_whitespace",
			"csv_pipe",
			"rfc_csv",
			"rfc_semicolon",
		},
		--- CSV/TSV highlighting for better data readability.
		--- Highlights columns in alternating colors.
	},
	{
		"jwalton512/vim-blade",
		ft = { "blade" },
		--- Syntax highlighting for Laravel Blade templates.
	},
}
