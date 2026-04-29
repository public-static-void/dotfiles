local utils = require("user.utils")

local cursorword = utils.safe_require("mini.cursorword")
if not cursorword then
	return
end

cursorword.setup({})

local function set_cursorword_hls()
	local function convert_hl(hl)
		if not hl then
			return {}
		end
		local new_hl = {}
		for k, v in pairs(hl) do
			if type(v) == "number" and k:match("^[fgbsp]g?$") then
				new_hl[k] = string.format("#%06x", v)
			else
				new_hl[k] = v
			end
		end
		return new_hl
	end

	vim.api.nvim_set_hl(0, "MiniCursorword", convert_hl(vim.api.nvim_get_hl(0, { name = "Search" })))
	vim.api.nvim_set_hl(0, "MiniCursorwordCurrent", convert_hl(vim.api.nvim_get_hl(0, { name = "Visual" })))
end
set_cursorword_hls()
vim.api.nvim_create_autocmd("ColorScheme", { callback = set_cursorword_hls })
