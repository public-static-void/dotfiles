-- General augroup
local general_group = vim.api.nvim_create_augroup("GeneralSettings", { clear = true })

vim.api.nvim_create_autocmd("BufWinEnter", {
	group = general_group,
	callback = function()
		vim.opt_local.formatoptions = "cjqt"
	end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
	group = general_group,
	callback = function()
		if not vim.bo.binary and vim.bo.filetype ~= "diff" then
			local view = vim.fn.winsaveview()
			vim.cmd([[%s/\s\+$//e]])
			vim.fn.winrestview(view)
		end
	end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
	group = general_group,
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

vim.api.nvim_create_autocmd("BufNewFile", {
	group = general_group,
	pattern = "*.*",
	callback = function()
		local ext = vim.fn.expand("<afile>:e")
		local sep = package.config:sub(1, 1)
		local skeleton = string.format("%s%sskeleton.%s", vim.fn.expand("~/.config/nvim/templates"), sep, ext)
		if vim.fn.filereadable(skeleton) == 1 then
			vim.cmd("0r " .. skeleton)
		end
	end,
})

-- Filetype-specific settings
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown", "gitcommit" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
		vim.opt_local.spelllang = { "de_de", "en_us" }
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "python",
	callback = function()
		vim.opt_local.tabstop = 4
		vim.opt_local.softtabstop = 4
		vim.opt_local.shiftwidth = 4
		vim.opt_local.smarttab = true
		vim.opt_local.expandtab = true
		vim.opt_local.autoindent = true
		vim.opt_local.smartindent = true
		vim.opt_local.colorcolumn = "80"
		vim.keymap.set("n", "<leader>e", ":sp | term python %<CR>:startinsert<CR>", { buffer = true })
	end,
})

-- Code runner keymaps for other filetypes
local runners = {
	javascript = "node %",
	java = "java %",
	go = "go run %",
	rust = "cargo run %",
	sh = "bash %",
	lua = "lua %",
	php = "php %",
}

for ft, cmd in pairs(runners) do
	vim.api.nvim_create_autocmd("FileType", {
		pattern = ft,
		callback = function()
			vim.keymap.set("n", "<leader>e", ":sp | term " .. cmd .. "<CR>:startinsert<CR>", { buffer = true })
		end,
	})
end
