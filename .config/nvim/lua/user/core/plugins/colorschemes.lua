--- Theme and colorscheme plugin collection
--- Provides multiple color/theme options, all lazy-loaded unless otherwise noted.
--- @type Plugin[]
return {
	{
		"lunarvim/colorschemes",
		--- Meta plugin collecting many common community colorschemes.
		lazy = true,
	},
	{
		"RRethy/nvim-base16",
		--- Base16 framework for consistent theme families across editors.
		lazy = true,
	},
	{
		"tomasiser/vim-code-dark",
		--- Dark Visual Studio Code-like theme.
		lazy = true,
	},
	{
		"Mofiqul/vscode.nvim",
		--- Lua-based VS Code theme implementation with light/dark toggle.
		lazy = true,
	},
	{
		"zacanger/angr.vim",
		--- Minimal dark colorscheme inspired by "angr".
		lazy = true,
	},
	{
		"mhinz/vim-janah",
		--- Subtle, low-contrast theme optimized for long coding sessions.
		lazy = true,
	},
	{
		"srcery-colors/srcery-vim",
		--- Vibrant retro-style theme with restrained color palette.
		lazy = true,
	},
	{
		"AlphaTechnolog/pywal.nvim",
		name = "pywal",
		lazy = true,
		--- Integrates pywal-generated colors into Neovim.
		--- Useful for matching dynamic system color schemes.
	},
}
