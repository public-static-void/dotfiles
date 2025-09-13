local utils = require("user.utils")

local sunglasses = utils.safe_require("sunglasses")
if not sunglasses then
	return
end

sunglasses.setup({
	filter_type = "SHADE",
	filter_percent = 0.25,
})
