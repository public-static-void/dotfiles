--- Theme and colorscheme plugin collection
--- Provides multiple color/theme options, all lazy-loaded unless otherwise noted.
--- @type table
return {
	{
		--- Meta plugin collecting many common community colorschemes.
		src = "https://github.com/lunarvim/colorschemes",
	},
	{
		--- Base16 framework for consistent theme families across editors.
		src = "https://github.com/RRethy/nvim-base16",
	},
	{
		--- Dark Visual Studio Code-like theme.
		src = "https://github.com/tomasiser/vim-code-dark",
	},
	{
		--- Lua-based VS Code theme implementation with light/dark toggle.
		src = "https://github.com/Mofiqul/vscode.nvim",
	},
	{
		--- Minimal dark colorscheme inspired by "angr".
		src = "https://github.com/zacanger/angr.vim",
	},
	{
		--- Subtle, low-contrast theme optimized for long coding sessions.
		src = "https://github.com/mhinz/vim-janah",
	},
	{
		--- Vibrant retro-style theme with restrained color palette.
		src = "https://github.com/srcery-colors/srcery-vim",
	},
	{
		--- Integrates pywal-generated colors into Neovim.
		--- Useful for matching dynamic system color schemes.
		src = "https://github.com/AlphaTechnolog/pywal.nvim",
	},
}
