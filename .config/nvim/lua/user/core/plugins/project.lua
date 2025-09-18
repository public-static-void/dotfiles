--- Project-level utilities
--- code running, SSH editing etc.
--- @type Plugin[]
return {
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
		"echasnovski/mini.misc",
		version = "*",
		--- Utility functions for working with buffers, windows, and tabs.
	},
}
