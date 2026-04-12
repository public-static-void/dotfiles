--- User interface plugins
--- Startup screen, tabline, statusline, file tree, terminal, etc.
--- @type Plugin[]
return {
	{
		"goolord/alpha-nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		--- Customizable startup screen/dashboard.
	},
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		--- Modern tabline with buffer indicators and icons.
	},
	{
		"nvim-lualine/lualine.nvim",
		event = "UIEnter",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		--- Statusline framework with icons and LSP indicators.
	},
	{
		"dstein64/nvim-scrollview",
		--- Scrollbar showing diff markers and diagnostics.
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		--- File explorer sidebar with git and diagnostics support.
	},
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = true,
		--- Integrated floating terminal with multiple layout modes.
	},
	{
		"nvim-mini/mini.indentscope",
		version = "*",
		--- Visual indication of current scope indentation block.
	},
	{
		"miversen33/sunglasses.nvim",
		event = "UIEnter",
		--- Dims inactive windows to emphasize active buffer.
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		--- Displays keybinding hints on partial leader input.
	},
	{
		"folke/trouble.nvim",
		branch = "main",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		cmd = { "Trouble", "TroubleToggle", "TroubleClose", "TroubleRefresh" },
		--- Centralized list of diagnostics, references, and quickfixes.
	},
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
		"HiPhish/rainbow-delimiters.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		event = { "BufReadPost", "BufNewFile" },
		--- Rainbow highlight for nested brackets and delimiters.
	},
	{
		"jiaoshijie/undotree",
		--- Provides a tree-like history of undos for branching timelines.
	},
}
