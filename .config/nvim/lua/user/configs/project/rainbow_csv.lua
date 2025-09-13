local utils = require("user.utils")

local rainbow_csv = utils.safe_require("rainbow_csv")
if not rainbow_csv then
	return
end

rainbow_csv.setup({})
