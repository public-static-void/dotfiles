local utils = require("user.utils")

local mkdir = utils.safe_require("mkdir")
if not mkdir then
	return
end

mkdir.setup({})
