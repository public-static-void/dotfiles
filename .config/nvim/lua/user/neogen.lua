local utils = require("user.utils")

local neogen = utils.safe_require("neogen")
if not neogen then
	return
end

neogen.setup({
	languages = {
		python = {
			template = {
				annotation_convention = "numpydoc",
			},
		},
	},
})
