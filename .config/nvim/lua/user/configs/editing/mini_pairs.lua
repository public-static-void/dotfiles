local utils = require("user.utils")

local mini_pairs = utils.safe_require("mini.pairs")
if not mini_pairs then
	return
end

mini_pairs.setup({})
