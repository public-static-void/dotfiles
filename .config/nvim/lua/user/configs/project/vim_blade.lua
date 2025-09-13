local utils = require("user.utils")

local vim_blade = utils.safe_require("vim-blade")
if not vim_blade then
	return
end

vim_blade.setup({})
