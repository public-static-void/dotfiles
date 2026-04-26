--- Filetype-specific enhancements
--- @type table
return {
	{
		--- Opens an external live preview for Markdown documents in browser.
		--- Configured to start automatically on buffer load.
		src = "https://github.com/iamcco/markdown-preview.nvim",
		name = "markdown-preview.nvim",
	},
	{
		--- CSV/TSV highlighting for better data readability.
		--- Highlights columns in alternating colors.
		src = "https://github.com/cameron-wags/rainbow_csv.nvim",
		name = "rainbow_csv.nvim",
	},
	{
		--- Syntax highlighting for Laravel Blade templates.
		src = "https://github.com/jwalton512/vim-blade",
		name = "vim-blade",
	},
}
