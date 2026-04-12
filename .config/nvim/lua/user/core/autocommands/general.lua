--- General Autocommands
-- Contains simple, global autocmds for cursor restoration,
-- whitespace cleanup, skeleton insertion, etc.

local group = vim.api.nvim_create_augroup("GeneralSettings", { clear = true })

--- Activate builtin undotree plugin
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		vim.cmd.packadd("nvim.undotree")
	end,
})

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
