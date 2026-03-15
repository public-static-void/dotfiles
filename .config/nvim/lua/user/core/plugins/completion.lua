--- Autocompletion engines and AI assistance
--- @type Plugin[]
return {
	{
		"saghen/blink.cmp",
		--- Core completion engine, lightweight successor to nvim-cmp.
		dependencies = {
			"rafamadriz/friendly-snippets",
			"Exafunction/windsurf.nvim",
			"milanglacier/minuet-ai.nvim",
		},
		version = "1.*",
		build = "cargo build --release",
		opts_extend = { "sources.default" },
	},
	{
		"Exafunction/windsurf.nvim",
		--- Provides Codeium AI completions via Windsurf client.
		--- Disabled cmp source to avoid duplicating with blink.cmp.
		dependencies = { "nvim-lua/plenary.nvim" },
		event = "VeryLazy",
	},
	{
		"milanglacier/minuet-ai.nvim",
		--- Provides local AI completion.
		dependencies = { "Saghen/blink.cmp", "nvim-lua/plenary.nvim" },
		event = "VeryLazy",
	},
}
