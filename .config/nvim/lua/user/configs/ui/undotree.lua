local utils = require("user.utils")

local undotree = utils.safe_require("undotree")
if not undotree then
	return
end

undotree.setup({})
