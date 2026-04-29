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
		--- Vibrant retro-style theme with restrained color palette.
		src = "https://github.com/srcery-colors/srcery-vim",
	},
}
