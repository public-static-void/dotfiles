--- Folding Autocommands
-- Handles fold refreshing, per-buffer fold method setup,
-- and automatic foldcolumn toggling.

--- Refresh folds when entering files (skip terminals or special buffers)
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "BufEnter" }, {
	callback = function()
		if vim.bo.buftype ~= "" or vim.bo.filetype == "toggleterm" then
			return
		end
		vim.schedule(function()
			if vim.bo.buftype == "" and vim.bo.filetype ~= "toggleterm" then
				vim.cmd("normal! zx")
			end
		end)
	end,
})

--- Auto-detect foldmethod: use Treesitter if parser exists, fallback to syntax
vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
	callback = function()
		if vim.bo.buftype ~= "" or vim.bo.filetype == "" then
			return
		end
		local lang = vim.treesitter.language.get_lang(vim.bo.filetype)
		if lang then
			vim.opt_local.foldmethod = "expr"
			vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
		else
			vim.opt_local.foldmethod = "syntax"
		end
	end,
})

--- Show or hide foldcolumn depending on whether there are closed folds in view
local function update_foldcolumn()
	local start_line = vim.fn.line("w0")
	local end_line = vim.fn.line("w$")
	local has_closed_fold = false
	for l = start_line, end_line do
		if vim.fn.foldclosed(l) ~= -1 then
			has_closed_fold = true
			break
		end
	end
	vim.wo.foldcolumn = has_closed_fold and "1" or "0"
end

vim.api.nvim_create_autocmd(
	{ "BufWinEnter", "WinScrolled", "CursorMoved", "BufEnter", "WinEnter" },
	{ callback = update_foldcolumn }
)
