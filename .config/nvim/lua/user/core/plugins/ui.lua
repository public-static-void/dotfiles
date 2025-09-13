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
		"nvim-lua/popup.nvim",
		--- Backport of vim’s popup API for Lua plugins.
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
		config = function()
			require("sunglasses").setup({
				filter_percent = 0.25,
			})
		end,
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
		opts = {},
	},
}
