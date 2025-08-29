local sep = package.config:sub(1, 1)

return {

	{
		"saghen/blink.cmp",
		dependencies = {
			"rafamadriz/friendly-snippets",
			"Exafunction/windsurf.nvim",
		},
		version = "1.*",
		build = "cargo build --release",
		opts_extend = { "sources.default" },
	},
	-- Codeium
	{
		"Exafunction/windsurf.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"saghen/blink.cmp",
		},
		config = function()
			require("codeium").setup({
				enable_cmp_source = false,
				config_path = vim.fn.stdpath("data") .. sep .. "codeium" .. sep .. "config.json",
			})
		end,
		event = "VeryLazy",
	},
}
