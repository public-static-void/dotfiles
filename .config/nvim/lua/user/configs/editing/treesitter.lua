local utils = require("user.utils")

local configs = utils.safe_require("nvim-treesitter.configs")
if not configs then
	return
end

configs.setup({
	prefer_git = true,
	ensure_installed = "all",
	sync_install = true,
	auto_install = true,
	ignore_install = {},
	autopairs = {
		enable = false,
	},
	highlight = {
		enable = true,
		disable = { "" }, -- list of languages that will be disabled
		additional_vim_regex_highlighting = false,
	},
	indent = { enable = false, disable = { "yaml" } },
})

-- Safe enable after parser ready (fixes range nil)
vim.api.nvim_create_autocmd("FileType", {
	callback = function()
		if vim.bo.buftype ~= "" then
			return
		end
		vim.schedule(function()
			vim.cmd("silent! TSBufEnable highlight")
		end)
	end,
})
