local utils = require("user.utils")

local flash = utils.safe_require("flash")
if not flash then
	return
end

flash.setup({})
