--- Autocompletion engines and AI assistance
--- @type Plugin[]
local sep = package.config:sub(1, 1)
return {
	{
		"saghen/blink.cmp",
		--- Core completion engine, lightweight successor to nvim-cmp.
		dependencies = {
			"rafamadriz/friendly-snippets",
			"Exafunction/windsurf.nvim",
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
		config = function()
			require("codeium").setup({
				enable_cmp_source = false,
				config_path = vim.fn.stdpath("data") .. sep .. "codeium" .. sep .. "config.json",
			})
		end,
	},
}
