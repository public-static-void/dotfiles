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
	-- Filetree
	{
		"nvim-tree/nvim-tree.lua",
		cmd = "NvimTreeToggle",
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
	-- Indent Color guide
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {},
		event = { "BufReadPost", "BufNewFile" },
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
}
