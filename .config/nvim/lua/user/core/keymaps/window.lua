--- Window splitting, resizing and navigation keymaps
--- @module "user.keymaps.window"

vim.keymap.set("n", "<M-v>", ":vsplit<CR>", { noremap = true, silent = true, desc = "Vertical split" })
vim.keymap.set("n", "<M-b>", ":split<CR>", { noremap = true, silent = true, desc = "Horizontal split" })
vim.keymap.set("n", "<M-x>", "<C-w>x", { noremap = true, silent = true, desc = "Swap split" })
vim.keymap.set("n", "<M-y>", "<C-w>H", { noremap = true, silent = true, desc = "Move split left" })
vim.keymap.set("n", "<M-c>", "<C-w>K", { noremap = true, silent = true, desc = "Move split up" })
vim.keymap.set("n", "<M-S-y>", "<C-w>L", { noremap = true, silent = true, desc = "Move split right" })
vim.keymap.set("n", "<M-S-c>", "<C-w>J", { noremap = true, silent = true, desc = "Move split down" })

vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true, silent = true, desc = "Focus left split" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { noremap = true, silent = true, desc = "Focus lower split" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { noremap = true, silent = true, desc = "Focus upper split" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { noremap = true, silent = true, desc = "Focus right split" })

vim.keymap.set("n", "<C-Left>", "<C-w>h", { noremap = true, silent = true, desc = "Focus left split" })
vim.keymap.set("n", "<C-Down>", "<C-w>j", { noremap = true, silent = true, desc = "Focus lower split" })
vim.keymap.set("n", "<C-Up>", "<C-w>k", { noremap = true, silent = true, desc = "Focus upper split" })
vim.keymap.set("n", "<C-Right>", "<C-w>l", { noremap = true, silent = true, desc = "Focus right split" })

vim.keymap.set("n", "<M-h>", ":vertical resize -1<CR>", { noremap = true, silent = true, desc = "Resize split left" })
vim.keymap.set("n", "<M-j>", ":resize -1<CR>", { noremap = true, silent = true, desc = "Resize split down" })
vim.keymap.set("n", "<M-k>", ":resize +1<CR>", { noremap = true, silent = true, desc = "Resize split up" })
vim.keymap.set("n", "<M-l>", ":vertical resize +1<CR>", { noremap = true, silent = true, desc = "Resize split right" })

vim.keymap.set(
	"n",
	"<M-Left>",
	":vertical resize -1<CR>",
	{ noremap = true, silent = true, desc = "Resize split left" }
)
vim.keymap.set("n", "<M-Down>", ":resize -1<CR>", { noremap = true, silent = true, desc = "Resize split down" })
vim.keymap.set("n", "<M-Up>", ":resize +1<CR>", { noremap = true, silent = true, desc = "Resize split up" })
vim.keymap.set(
	"n",
	"<M-Right>",
	":vertical resize +1<CR>",
	{ noremap = true, silent = true, desc = "Resize split right" }
)

vim.keymap.set("n", "<M-s>", "<C-w>c", { noremap = true, silent = true, desc = "Close current split" })
