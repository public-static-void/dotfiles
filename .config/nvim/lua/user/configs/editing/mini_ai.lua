local utils = require("user.utils")

local mini_ai = utils.safe_require("mini.ai")
if not mini_ai then
	return
end

mini_ai.setup({})
