--- Debugging related keymaps and utilities
--- @module "user.keymaps.dap"

vim.keymap.set(
	"n",
	"<leader>p",
	":DapToggleBreakpoint<CR>",
	{ noremap = true, silent = true, desc = "DAP: Toggle breakpoint" }
)
vim.keymap.set("n", "<leader>c", ":DapContinue<CR>", { noremap = true, silent = true, desc = "DAP: Continue" })
vim.keymap.set("n", "<leader>o", ":DapStepOver<CR>", { noremap = true, silent = true, desc = "DAP: Step over" })
vim.keymap.set("n", "<leader>i", ":DapStepInto<CR>", { noremap = true, silent = true, desc = "DAP: Step into" })
