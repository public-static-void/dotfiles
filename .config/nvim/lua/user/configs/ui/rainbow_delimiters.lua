local utils = require("user.utils")

local rainbow = utils.safe_require("rainbow-delimiters.setup")
if not rainbow then
	return
end

rainbow.setup({})
