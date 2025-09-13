--- Debug Adapter Protocol integration
--- Provides debugging framework with UI, UI hints, and language adapters.
--- @type Plugin[]
return {
	{
		"mfussenegger/nvim-dap",
		--- Core DAP client. Deferred initialization to avoid startup slowdowns.
		event = "VeryLazy",
		dependencies = {
			"rcarriga/nvim-dap-ui", -- Rich UI for breakpoints/frames
			"nvim-neotest/nvim-nio", -- Async primitives for debugging
			"jay-babu/mason-nvim-dap.nvim", -- Automatic adapter installation
			"theHamsta/nvim-dap-virtual-text", -- Inline values during debugging
			"leoluz/nvim-dap-go", -- Go DAP adapter integration
			"mfussenegger/nvim-dap-python", -- Python debug setup
			"simrat39/rust-tools.nvim", -- Rust debugging utilities
		},
	},
}
