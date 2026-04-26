--- User interface plugins
--- Startup screen, tabline, statusline, file tree, terminal, etc.
--- @type table
return {
	{
		--- Dependency for multiple UI plugins.
		src = "https://github.com/nvim-tree/nvim-web-devicons",
	},
	{
		--- Dependency for neo-tree.nvim.
		src = "https://github.com/nvim-lua/plenary.nvim",
	},
	{
		--- Dependency for neo-tree.nvim.
		src = "https://github.com/MunifTanjim/nui.nvim",
	},
	{
		--- Customizable startup screen/dashboard.
		src = "https://github.com/goolord/alpha-nvim",
	},
	{
		--- Modern tabline with buffer indicators and icons.
		src = "https://github.com/akinsho/bufferline.nvim",
		version = vim.version.range("*"),
	},
	{
		--- Statusline framework with icons and LSP indicators.
		src = "https://github.com/nvim-lualine/lualine.nvim",
	},
	{
		--- Scrollbar showing diff markers and diagnostics.
		src = "https://github.com/dstein64/nvim-scrollview",
	},
	{
		--- File explorer sidebar with git and diagnostics support.
		src = "https://github.com/nvim-neo-tree/neo-tree.nvim",
		version = "v3.x",
	},
	{
		--- Integrated floating terminal with multiple layout modes.
		src = "https://github.com/akinsho/toggleterm.nvim",
		version = vim.version.range("*"),
	},
	{
		--- Visual indication of current scope indentation block.
		src = "https://github.com/nvim-mini/mini.indentscope",
		version = vim.version.range("*"),
	},
	{
		--- Dims inactive windows to emphasize active buffer.
		src = "https://github.com/miversen33/sunglasses.nvim",
	},
	{
		--- Displays keybinding hints on partial leader input.
		src = "https://github.com/folke/which-key.nvim",
	},
	{
		--- Centralized list of diagnostics, references, and quickfixes.
		src = "https://github.com/folke/trouble.nvim",
		version = "main",
	},
	{
		--- Git hunk signs, blame, and inline actions.
		src = "https://github.com/lewis6991/gitsigns.nvim",
	},
	{
		--- Fuzzy finder built on fzf with Lua integration.
		src = "https://github.com/ibhagwan/fzf-lua",
	},
	{
		--- Symbol outline sidebar synced with LSP/TS.
		src = "https://github.com/stevearc/aerial.nvim",
	},
	{
		--- Rainbow highlight for nested brackets and delimiters.
		src = "https://github.com/HiPhish/rainbow-delimiters.nvim",
	},
}
