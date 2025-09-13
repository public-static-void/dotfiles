local utils = require("user.utils")

local scrollview = utils.safe_require("scrollview")
if not scrollview then
	return
end

scrollview.setup({
	excluded_filetypes = { "alpha" },
	current_only = true,
	base = "right",
	column = 1,
	hide_bar_for_insert = true,
	signs_hidden_for_insert = { "all" },
	signs_scrollbar_overlap = "over",
})
