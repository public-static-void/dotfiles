local utils = require("user.utils")

local mini_cursorword = utils.safe_require("mini.cursorword")
if not mini_cursorword then
	return
end

mini_cursorword.setup({})
