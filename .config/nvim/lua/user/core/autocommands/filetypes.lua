--- Filetype Autocommands
-- Filetype-specific options and detection.

--- Markdown and gitcommit: wrap text and enable spellchecking
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown", "gitcommit" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spelllang = { "de", "en" }
	end,
})

--- Python: enforce PEP8 indentation and colorcolumn
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
	end,
})

--- YAML: detect Ansible playbooks/roles and set filetype accordingly
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.yml", "*.yaml" },
	callback = function()
		local path = vim.fn.expand("%:p")
		if path:match("/roles/") or path:match("/playbooks/") or path:match("/tasks/") then
			vim.bo.filetype = "yaml.ansible"
		end
	end,
})
