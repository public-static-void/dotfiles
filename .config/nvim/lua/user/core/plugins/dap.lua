--- Debug Adapter Protocol integration
--- Provides debugging framework with UI, UI hints, and language adapters.
--- @type Plugin[]
return {
	{
		--- Core DAP client. Deferred initialization to avoid startup slowdowns.
		src = "https://github.com/mfussenegger/nvim-dap",
	},
	{
		--- Rich UI for breakpoints/frames.
		src = "https://github.com/rcarriga/nvim-dap-ui",
	},
	{
		--- Async primitives for debugging.
		src = "https://github.com/nvim-neotest/nvim-nio",
	},
	{
		--- Automatic adapter installation.
		src = "https://github.com/jay-babu/mason-nvim-dap.nvim",
	},
	{
		--- Inline values during debugging.
		src = "https://github.com/theHamsta/nvim-dap-virtual-text",
	},
}
