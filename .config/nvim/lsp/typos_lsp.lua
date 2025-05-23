local utils = require("user.utils")

local handlers = utils.safe_require("user.lsp.handlers")
if not handlers then
	return
end

local home = os.getenv("HOME")

return {
	filetypes = {
		"*",
	},
	init_options = {
		diagnosticSeverity = "Warning",
		config = home .. "/.config/nvim/lua/typos.toml",
	},
}
