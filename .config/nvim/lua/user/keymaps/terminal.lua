--- Terminal mode keymaps
--- @module user.keymaps.terminal

local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<C-t>", ":ToggleTerm<CR>", { noremap = true, silent = true, desc = "Toggle terminal" })
vim.keymap.set("t", "<C-t>", [[<C-\><C-n>:ToggleTerm<CR>]], opts)
vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-W>h]], opts)
vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-W>j]], opts)
vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-W>k]], opts)
vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-W>l]], opts)
vim.keymap.set("t", "<C-Left>", [[<C-\><C-n><C-W>h]], opts)
vim.keymap.set("t", "<C-Down>", [[<C-\><C-n><C-W>j]], opts)
vim.keymap.set("t", "<C-Up>", [[<C-\><C-n><C-W>k]], opts)
vim.keymap.set("t", "<C-Right>", [[<C-\><C-n><C-W>l]], opts)
