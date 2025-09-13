local utils = require("user.utils")

local highlight = utils.safe_require("nvim-highlight-colors")
if not highlight then
	return
end

highlight.setup({})
