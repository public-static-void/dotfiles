local utils = require("user.utils")

local wk = utils.safe_require("which-key")
if not wk then
	vim.notify("which-key.nvim not available", vim.log.levels.WARN)
	return
end

wk.setup({
	win = {
		border = "rounded",
		padding = { 1, 2 },
		title = true,
		title_pos = "center",
		zindex = 1000,
		wo = {
			winblend = 10,
		},
	},
	icons = {
		breadcrumb = "»",
		separator = "➜",
		group = "+",
	},
	layout = {
		width = { min = 20 },
		spacing = 3,
	},
})
