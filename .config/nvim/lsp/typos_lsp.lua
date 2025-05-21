local home = os.getenv("HOME")
local utils = require("user.utils")

local handlers = utils.safe_require("user.lsp.handlers")
if not handlers then
	return
end

return {
	filetypes = {
		"*",
	},
	init_options = {
		diagnosticSeverity = "Warning",
		config = home .. "/.config/nvim/lua/typos.toml",
	},
}
