local utils = require("user.utils")

local bufdelete = utils.safe_require("bufdelete")
if not bufdelete then
	return
end

bufdelete.setup({})
