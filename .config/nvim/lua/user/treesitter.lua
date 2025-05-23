local utils = require("user.utils")

local configs = utils.safe_require("nvim-treesitter.configs")
if not configs then
	return
end

configs.setup({
	prefer_git = true,
	ensure_installed = "all",
	sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
	auto_install = true,
	ignore_install = {},
	autopairs = {
		enable = true,
	},
	highlight = {
		enable = true,
		disable = { "" }, -- list of language that will be disabled
		additional_vim_regex_highlighting = false,
	},
	indent = { enable = true, disable = { "yaml" } },
})
