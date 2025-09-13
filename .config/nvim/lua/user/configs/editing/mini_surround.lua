local utils = require("user.utils")

local mini_surround = utils.safe_require("mini.surround")
if not mini_surround then
	return
end

mini_surround.setup({})
