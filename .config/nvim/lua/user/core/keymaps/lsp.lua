--- LSP related keymaps and utilities
--- @module user.keymaps.lsp

local utils = require("user.utils")
local modules = {
	conform = utils.safe_require("conform"),
	trouble = utils.safe_require("trouble"),
	neogen = utils.safe_require("neogen"),
}
for _, mod in pairs(modules) do
	if not mod then
		return
	end
end
local conform, trouble, neogen = modules.conform, modules.trouble, modules.neogen

vim.keymap.set("n", "<leader>f", function()
	if not vim.bo.modifiable then
		vim.notify("Buffer is not modifiable!", vim.log.levels.WARN)
		return
	end
	if conform then
		local formatted = conform.format({ async = true, lsp_fallback = false })
		if formatted then
			return
		end
	end
	local bufnr = vim.api.nvim_get_current_buf()
	local can_format_lsp = false
	for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
		if client.supports_method and client:supports_method("textDocument/formatting") then
			can_format_lsp = true
			break
		end
	end
	if can_format_lsp then
		vim.lsp.buf.format({ async = true })
	else
		local pos = vim.api.nvim_win_get_cursor(0)
		vim.cmd("silent normal! gg=G")
		vim.cmd([[%s/\s\+$//e]])
		vim.cmd([[%s#\($\n\)\+\%$##e]])
		local last_line = vim.api.nvim_buf_line_count(0)
		local new_line = math.min(pos[1], last_line)
		vim.api.nvim_win_set_cursor(0, { new_line, pos[2] })
	end
end, { noremap = true, silent = true, desc = "Format buffer: conform.nvim, LSP, or native fallback" })

vim.keymap.set("n", "<leader>n", function()
	vim.diagnostic.jump({ count = 1, float = true })
end, { noremap = true, silent = true, desc = "LSP: Next diagnostic" })

vim.keymap.set("n", "<leader>b", function()
	vim.diagnostic.jump({ count = -1, float = true })
end, { noremap = true, silent = true, desc = "LSP: Previous diagnostic" })

vim.keymap.set("n", "<leader>v", function()
	if trouble then
		trouble.toggle("diagnostics")
	else
		vim.diagnostic.setloclist()
	end
end, { noremap = true, silent = true, desc = "LSP: Diagnostics" })

vim.keymap.set("n", "K", vim.lsp.buf.hover, { noremap = true, silent = true, desc = "LSP: Hover" })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { noremap = true, silent = true, desc = "LSP: Go to declaration" })

vim.keymap.set("n", "gd", function()
	if trouble then
		trouble.toggle("lsp_definitions")
	else
		vim.lsp.buf.definition()
	end
end, { noremap = true, silent = true, desc = "LSP: Go to definition" })

vim.keymap.set("n", "gi", function()
	if trouble then
		trouble.toggle("lsp_implementations")
	else
		vim.lsp.buf.implementation()
	end
end, { noremap = true, silent = true, desc = "LSP: Go to implementation (Trouble)" })

vim.keymap.set("n", "gr", function()
	if trouble then
		trouble.toggle("lsp_references")
	else
		vim.lsp.buf.references()
	end
end, { noremap = true, silent = true, desc = "LSP: References" })

vim.keymap.set("n", "<leader>x", function()
	if trouble then
		trouble.toggle("quickfix")
	else
		vim.cmd("copen")
	end
end, { noremap = true, silent = true, desc = "Quickfix list" })

vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, { noremap = true, silent = true, desc = "LSP: Signature help" })
vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, { noremap = true, silent = true, desc = "LSP: Rename symbol" })
vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, { noremap = true, silent = true, desc = "LSP: Code action" })

vim.keymap.set(
	"n",
	"<leader>m",
	vim.diagnostic.open_float,
	{ noremap = true, silent = true, desc = "LSP: Show diagnostic float" }
)

vim.keymap.set("n", "<Leader>s", function()
	if neogen then
		neogen.generate()
	else
		vim.notify("Neogen not found!", vim.log.levels.WARN)
	end
end, { noremap = true, silent = true, desc = "Generate docstring" })
