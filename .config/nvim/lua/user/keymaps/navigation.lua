--- Navigation and movement related keymaps
--- @module user.keymaps.navigation

vim.keymap.set({ "n", "v", "o" }, "<S-h>", "0", { noremap = true, silent = true, desc = "Go to line start" })
vim.keymap.set({ "n", "v", "o" }, "<S-l>", "$", { noremap = true, silent = true, desc = "Go to line end" })
vim.keymap.set({ "n", "v", "o" }, "<S-j>", "G", { noremap = true, silent = true, desc = "Go to file end" })
vim.keymap.set({ "n", "v", "o" }, "<S-k>", "gg", { noremap = true, silent = true, desc = "Go to file start" })
vim.keymap.set({ "n", "v", "o" }, "<S-Left>", "0", { noremap = true, silent = true, desc = "Go to line start" })
vim.keymap.set({ "n", "v", "o" }, "<S-Right>", "$", { noremap = true, silent = true, desc = "Go to line end" })
vim.keymap.set({ "n", "v", "o" }, "<S-Down>", "G", { noremap = true, silent = true, desc = "Go to file end" })
vim.keymap.set({ "n", "v", "o" }, "<S-Up>", "gg", { noremap = true, silent = true, desc = "Go to file start" })

vim.keymap.set({ "n", "v" }, "j", "gj", { noremap = true, silent = true, desc = "Move down (visual line)" })
vim.keymap.set({ "n", "v" }, "k", "gk", { noremap = true, silent = true, desc = "Move up (visual line)" })
vim.keymap.set({ "n", "v" }, "<Down>", "gj", { noremap = true, silent = true, desc = "Move down (visual line)" })
vim.keymap.set({ "n", "v" }, "<Up>", "gk", { noremap = true, silent = true, desc = "Move up (visual line)" })
vim.keymap.set("i", "<Down>", "<C-o>gj", { noremap = true, silent = true, desc = "Move down (visual line)" })
vim.keymap.set("i", "<Up>", "<C-o>gk", { noremap = true, silent = true, desc = "Move up (visual line)" })

vim.keymap.set({ "n", "v" }, "<C-u>", "<C-u>zz", { noremap = true, silent = true, desc = "Scroll up and center" })
vim.keymap.set({ "n", "v" }, "<C-d>", "<C-d>zz", { noremap = true, silent = true, desc = "Scroll down and center" })
