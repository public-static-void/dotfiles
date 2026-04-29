local utils = require("user.utils")

local indentscope = utils.safe_require("mini.indentscope")
if not indentscope then
	return
end

local math = math
local pcall = pcall

-- List of filetypes to disable mini.indentscope in
local disabled_filetypes = {
	"NvimTree",
	"Trouble",
	"alpha",
	"dashboard",
	"help",
	"lazy",
	"lazygit",
	"mason",
	"neo-tree",
	"text",
	"trouble",
}

local group = vim.api.nvim_create_augroup("MiniIndentscopeDisable", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = disabled_filetypes,
	callback = function()
		vim.b.miniindentscope_disable = true
	end,
})

local rainbow_hl_groups = {
	"RainbowDelimiterCyan",
	"RainbowDelimiterRed",
	"RainbowDelimiterYellow",
	"RainbowDelimiterBlue",
	"RainbowDelimiterOrange",
	"RainbowDelimiterGreen",
	"RainbowDelimiterViolet",
}

local php_scope_order = { 1, 5, 2, 6, 3, 7, 4 }

local function get_indent_scope_level()
	local scope = indentscope.get_scope()
	if not (scope and scope.body and scope.body.indent) then
		return nil
	end
	return math.floor(scope.body.indent / vim.o.shiftwidth)
end

local function get_lang_offset()
	local ft = vim.bo.filetype
	if ft == "python" then
		return -1
	end
	return 0
end

local function get_rainbow_hl(level)
	if not level or level < 0 then
		return nil
	end
	local ft = vim.bo.filetype
	if ft == "php" then
		local idx = (level % #php_scope_order) + 1
		return rainbow_hl_groups[php_scope_order[idx]]
	else
		local offset = get_lang_offset()
		local idx = ((level + offset) % #rainbow_hl_groups) + 1
		return rainbow_hl_groups[idx]
	end
end

local function update_indentscope_color()
	local level = get_indent_scope_level()
	local hl_group = get_rainbow_hl(level)

	if not hl_group then
		vim.cmd("highlight link MiniIndentscopeSymbol Identifier")
		return
	end

	local ok, hl_info = pcall(vim.api.nvim_get_hl, 0, { name = hl_group })

	if not ok or not hl_info or not hl_info.fg then
		vim.cmd("highlight link MiniIndentscopeSymbol Identifier")
		return
	end

	vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", { fg = hl_info.fg })
end

vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "BufEnter" }, {
	pattern = "*",
	callback = update_indentscope_color,
})

indentscope.setup({
	symbol = "│",
	options = { try_as_border = true },
})

update_indentscope_color()
