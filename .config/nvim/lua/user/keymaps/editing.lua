--- Editing related keymaps: registers, indentation, yank/paste
--- @module user.keymaps.editing

vim.keymap.set("v", "p", '"_dP', { noremap = true, silent = true, desc = "Paste without overwriting register" })
vim.keymap.set("x", "p", "pgvy", { noremap = true, silent = true, desc = "Paste and reselect in visual mode" })
vim.keymap.set("v", "y", "ygv<Esc>", { noremap = true, silent = true, desc = "Yank and reselect in visual mode" })

vim.keymap.set("v", "<", "<gv", { noremap = true, silent = true, desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { noremap = true, silent = true, desc = "Indent right and reselect" })
vim.keymap.set({ "i" }, "<S-Tab>", "<BS>", { noremap = true, silent = true, desc = "Un-Tab" })

-- Move text up/down in normal and visual modes
vim.keymap.set("n", "<C-M-j>", ":m .+1<CR>==", { noremap = true, silent = true, desc = "Move line down" })
vim.keymap.set("n", "<C-M-k>", ":m .-2<CR>==", { noremap = true, silent = true, desc = "Move line up" })
vim.keymap.set("v", "<C-M-j>", ":m .+1<CR>==", { noremap = true, silent = true, desc = "Move selection down" })
vim.keymap.set("v", "<C-M-k>", ":m .-2<CR>==", { noremap = true, silent = true, desc = "Move selection up" })
vim.keymap.set("x", "<C-M-j>", ":m '>+1<CR>gv-gv", { noremap = true, silent = true, desc = "Move block down" })
vim.keymap.set("x", "<C-M-k>", ":m '<-2<CR>gv-gv", { noremap = true, silent = true, desc = "Move block up" })
