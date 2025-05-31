local utils = require("user.utils")

local handlers = utils.safe_require("user.lsp.handlers")
if not handlers then
	return
end

local sep = package.config:sub(1, 1)
local config_path = vim.fn.stdpath("config") .. sep .. "lua" .. sep .. "typos.toml"

return {
	filetypes = {
		"*",
	},
	init_options = {
		diagnosticSeverity = "Warning",
		config = config_path,
	},
}
