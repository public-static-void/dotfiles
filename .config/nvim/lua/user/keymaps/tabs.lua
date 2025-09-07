--- Tabs related keymaps
--- @module user.keymaps.tabs

vim.keymap.set("n", "<leader><Tab>", "gt", { noremap = true, silent = true, desc = "Next tab" })
vim.keymap.set("n", "<leader><S-Tab>", "gT", { noremap = true, silent = true, desc = "Previous tab" })
vim.keymap.set("n", "<leader>w", ":tabnew<CR>", { noremap = true, silent = true, desc = "New tab" })
vim.keymap.set("n", "<leader>q", ":tabclose<CR>", { noremap = true, silent = true, desc = "Close tab" })

for i = 1, 9 do
	vim.keymap.set("n", "<leader>" .. i, i .. "gt", { noremap = true, silent = true, desc = "Go to tab " .. i })
end
