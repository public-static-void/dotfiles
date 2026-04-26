--- Autocompletion engines and AI assistance
--- @type table
return {
	{
		--- Snippet collection for completion engines.
		src = "https://github.com/rafamadriz/friendly-snippets",
	},
	{
		--- Dependency for windsurf.nvim.
		src = "https://github.com/nvim-lua/plenary.nvim",
	},
	{
		--- Provides Codeium AI completions via Windsurf client.
		--- Disabled cmp source to avoid duplicating with blink.cmp.
		src = "https://github.com/Exafunction/windsurf.nvim",
	},
	{
		--- Core completion engine, lightweight successor to nvim-cmp.
		src = "https://github.com/saghen/blink.cmp",
		version = vim.version.range("1.*"),
	},
	{
		--- Provides local AI completion.
		src = "https://github.com/milanglacier/minuet-ai.nvim",
	},
}
