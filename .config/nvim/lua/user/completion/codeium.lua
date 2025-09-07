local utils = require("user.utils")

local codeium = utils.safe_require("codeium")
if not codeium then
	return
end

local sep = package.config:sub(1, 1)

codeium.setup({
	enable_cmp_source = false,
	config_path = vim.fn.stdpath("data") .. sep .. "codeium" .. sep .. "config.json",
})
