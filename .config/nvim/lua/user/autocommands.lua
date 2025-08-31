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

-- Delayed fold refresh after file read/buffer enter,
-- but skip terminal/toggleterm buffers
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "BufEnter" }, {
	callback = function()
		-- Skip non-file buffers like terminal, help, quickfix, etc.
		if vim.bo.buftype ~= "" or vim.bo.filetype == "toggleterm" then
			return
		end

		vim.schedule(function()
			-- Double check again inside scheduled callback
			if vim.bo.buftype == "" and vim.bo.filetype ~= "toggleterm" then
				vim.cmd("normal! zx")
			end
		end)
	end,
})

-- Auto-detect fold method per buffer. Use Treesitter folding only if parser is available, otherwise fallback to syntax folding
vim.api.nvim_create_autocmd({ "FileType" }, {
	callback = function()
		if require("nvim-treesitter.parsers").has_parser() then
			vim.opt.foldmethod = "expr"
			vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
		else
			vim.opt.foldmethod = "syntax"
			vim.opt.foldexpr = ""
		end
	end,
})

-- Show fold column when there are closed folds, else hide it
local function update_foldcolumn()
	local win = vim.api.nvim_get_current_win()
	-- Check for any closed folds in the visible window lines
	local start_line = vim.fn.line("w0")
	local end_line = vim.fn.line("w$")
	local has_closed_fold = false
	for l = start_line, end_line do
		if vim.fn.foldclosed(l) ~= -1 then
			has_closed_fold = true
			break
		end
	end
	if has_closed_fold then
		vim.wo.foldcolumn = "1"
	else
		vim.wo.foldcolumn = "0"
	end
end

vim.api.nvim_create_autocmd(
	{ "BufWinEnter", "WinScrolled", "CursorMoved", "BufEnter", "WinEnter" },
	{ callback = update_foldcolumn }
)

--- Filetype-specific settings

-- Text
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown", "gitcommit" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
		vim.opt_local.spelllang = { "de_de", "en_us" }
	end,
})

-- Python
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

-- Ansible
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.yml", "*.yaml" },
	callback = function()
		local path = vim.fn.expand("%:p")
		if path:match("/roles/") or path:match("/playbooks/") or path:match("/tasks/") then
			vim.bo.filetype = "yaml.ansible"
		end
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
