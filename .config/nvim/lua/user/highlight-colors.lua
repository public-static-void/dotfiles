local utils = require("user.utils")

local colors = utils.safe_require("nvim-highlight-colors")
if not colors then
	return
end

colors.setup({})
