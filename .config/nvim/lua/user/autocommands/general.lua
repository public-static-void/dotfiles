--- General Autocommands
-- Contains simple, global autocmds for cursor restoration,
-- whitespace cleanup, skeleton insertion, etc.

local group = vim.api.nvim_create_augroup("GeneralSettings", { clear = true })

--- Set recommended formatoptions on window enter
vim.api.nvim_create_autocmd("BufWinEnter", {
	group = group,
	callback = function()
		vim.opt_local.formatoptions = "cjqt"
	end,
})

--- Remove trailing whitespace before saving (except in diffs and binary files)
vim.api.nvim_create_autocmd("BufWritePre", {
	group = group,
	callback = function()
		if not vim.bo.binary and vim.bo.filetype ~= "diff" then
			local view = vim.fn.winsaveview()
			vim.cmd([[%s/\s\+$//e]])
			vim.fn.winrestview(view)
		end
	end,
})

--- Restore cursor to the last known position when reopening a file
vim.api.nvim_create_autocmd("BufReadPost", {
	group = group,
	callback = function()
		if
			vim.fn.line([['"]]) >= 1
			and vim.fn.line([['"]]) <= vim.fn.line("$")
			and not vim.bo.filetype:match("commit")
		then
			vim.cmd([[normal! g`"]])
		end
	end,
})

--- Auto-insert template skeleton files on creation, if available
vim.api.nvim_create_autocmd("BufNewFile", {
	group = group,
	pattern = "*.*",
	callback = function()
		local ext = vim.fn.expand("<afile>:e")
		local skeleton = string.format("%s/skeleton.%s", vim.fn.expand("~/.config/nvim/templates"), ext)
		if vim.fn.filereadable(skeleton) == 1 then
			vim.cmd("0r " .. skeleton)
		end
	end,
})
