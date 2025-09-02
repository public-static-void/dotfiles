local utils = require("user.utils")

local cursorword = utils.safe_require("mini.cursorword")
if not cursorword then
	return
end

cursorword.setup({})

local function set_cursorword_hls()
	vim.api.nvim_set_hl(0, "MiniCursorword", vim.api.nvim_get_hl(0, { name = "Search" }))
	vim.api.nvim_set_hl(0, "MiniCursorwordCurrent", vim.api.nvim_get_hl(0, { name = "Visual" }))
end
set_cursorword_hls()
vim.api.nvim_create_autocmd("ColorScheme", { callback = set_cursorword_hls })
