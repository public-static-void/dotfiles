return {
	-- Startup screen
	{
		"goolord/alpha-nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	-- Tabline
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	-- Statusline
	{
		"nvim-lualine/lualine.nvim",
		event = "UIEnter",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	-- Scrollbar
	{
		"dstein64/nvim-scrollview",
	},
	-- Filetree
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-tree/nvim-web-devicons",
		},
	},
	-- Terminal
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = true,
	},
	-- Popup API from vim in Neovim
	{
		"nvim-lua/popup.nvim",
	},
	-- Indent Scope
	{
		"nvim-mini/mini.indentscope",
		version = "*",
	},
	-- Dim inactive windows
	{
		"miversen33/sunglasses.nvim",
		event = "UIEnter",
		config = function()
			require("sunglasses").setup({
				filter_percent = 0.25,
			})
		end,
	},
	-- Keymaps
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
	},
	-- Error handling
	{
		"folke/trouble.nvim",
		branch = "main", -- or "v3.x" for the latest version
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {}, -- you can add custom settings here if desired
		cmd = { "Trouble", "TroubleToggle", "TroubleClose", "TroubleRefresh" }, -- lazy-load on command
	},
}
