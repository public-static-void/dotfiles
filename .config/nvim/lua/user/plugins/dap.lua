return {
	-- Debug Adapter Protocol
	{
		"mfussenegger/nvim-dap",
		event = "VeryLazy",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
			"jay-babu/mason-nvim-dap.nvim",
			"theHamsta/nvim-dap-virtual-text",
			"leoluz/nvim-dap-go",
			"mfussenegger/nvim-dap-python",
			"simrat39/rust-tools.nvim",
		},
	},
}
