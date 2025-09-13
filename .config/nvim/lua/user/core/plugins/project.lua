--- Project-level utilities
--- Git, pickers, outline, code running, SSH editing etc.
--- @type Plugin[]
return {
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPost", "BufNewFile" },
		--- Git hunk signs, blame, and inline actions.
	},
	{
		"ibhagwan/fzf-lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		--- Fuzzy finder built on fzf with Lua integration.
	},
	{
		"stevearc/aerial.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		--- Symbol outline sidebar synced with LSP/TS.
	},
	{
		"jghauser/mkdir.nvim",
		event = { "BufWritePre" },
		--- Auto-create missing directories on write.
	},
	{
		"CRAG666/code_runner.nvim",
		config = true,
		--- Execute code snippets or files within terminal buffers.
	},
	{
		"chipsenkbeil/distant.nvim",
		branch = "v0.3",
		--- Remote file editing and execution over SSH.
		config = function()
			require("distant"):setup()
		end,
	},
}
