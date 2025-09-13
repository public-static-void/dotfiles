local utils = require("user.utils")

local trouble = utils.safe_require("trouble")
if not trouble then
	return
end

trouble.setup({})
