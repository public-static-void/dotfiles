--- Project-level utilities
--- code running, etc.
--- @type table
return {
	{
		--- Auto-create missing directories on write.
		src = "https://github.com/jghauser/mkdir.nvim",
	},
	{
		--- Execute code snippets or files within terminal buffers.
		src = "https://github.com/CRAG666/code_runner.nvim",
	},
	{
		--- Utility functions for working with buffers, windows, and tabs.
		src = "https://github.com/echasnovski/mini.misc",
		version = vim.version.range("*"),
	},
}
