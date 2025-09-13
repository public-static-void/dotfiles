local utils = require("user.utils")

local hardtime = utils.safe_require("hardtime")
if not hardtime then
	return
end

hardtime.setup({
	disabled_keys = {
		["<Up>"] = false,
		["<Down>"] = false,
		["<Left>"] = false,
		["<Right>"] = false,
	},
	disable_mouse = false,
})
