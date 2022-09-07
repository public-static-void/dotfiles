local opts = { noremap = true, silent = true }

local comm_opts = { noremap = true, silent = false }

-- Shorten function name.
local keymap = vim.api.nvim_set_keymap

-- Leader key.
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- Modes:
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c".

-- Commands --

-- Fix some common command typos.
keymap("c", "W", "w", comm_opts)
keymap("c", "Q", "q", comm_opts)

keymap("c", "WQ", "wq", comm_opts)
keymap("c", "Wq", "wq", comm_opts)
keymap("c", "wQ", "wq", comm_opts)

keymap("c", "qw", "wq", comm_opts)
keymap("c", "qW", "wq", comm_opts)
keymap("c", "Qw", "wq", comm_opts)
keymap("c", "QW", "wq", comm_opts)

keymap("c", "QA", "qa", comm_opts)
keymap("c", "Qa", "qa", comm_opts)
keymap("c", "qA", "qa", comm_opts)

-- Enable to edit protected files.
keymap("c", "w!!", "w !sudo tee %", comm_opts)

-- Search --

-- Remove last search highlighting.
keymap("n", "<ESC>", ":noh<CR><ESC>", opts)

-- Registers --

-- Prevent selecting and pasting from overwriting what's originally copied.
keymap("v", "p", '"_dP', opts)
keymap("x", "p", "pgvy", opts)

-- Keep cursor at the bottom of the visual selection after yanking it.
keymap("v", "y", "ygv<Esc>", opts)

-- Navigation --

-- Goto start/end of line/document.
keymap("", "<S-h>", "0", opts)
keymap("", "<S-j>", "G", opts)
keymap("", "<S-k>", "gg", opts)
keymap("", "<S-l>", "$", opts)

keymap("", "<S-Left>", "0", opts)
keymap("", "<S-Down>", "G", opts)
keymap("", "<S-Up>", "gg", opts)
keymap("", "<S-Right>", "$", opts)

-- Don't skip line wraps while moving over them.
keymap("", "j", "gj", opts)
keymap("", "k", "gk", opts)

keymap("", "<Down>", "gj", opts)
keymap("", "<Up>", "gk", opts)

keymap("i", "<Down>", "<C-o>gj", opts)
keymap("i", "<Up>", "<C-o>gk", opts)

-- Stay in indent mode.
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down.
keymap("n", "<C-M-j>", ":m .+1<CR>==", opts)
keymap("n", "<C-M-k>", ":m .-2<CR>==", opts)

keymap("v", "<C-M-j>", ":m .+1<CR>==", opts)
keymap("v", "<C-M-k>", ":m .-2<CR>==", opts)

keymap("x", "<C-M-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<C-M-k>", ":move '<-2<CR>gv-gv", opts)

-- Splits --

-- Open new vertical/horizontal split.
keymap("n", "<M-v>", ":vsplit<CR>", opts)
keymap("n", "<M-b>", ":split<CR>", opts)

-- Swap splits positions.
keymap("n", "<M-x>", "<C-w>x", opts)

-- Move splits.
keymap("n", "<M-y>", "<C-w><S-h>", opts)
keymap("n", "<M-c>", "<C-w><S-k>", opts)
keymap("n", "<M-S-y>", "<C-w><S-l>", opts)
keymap("n", "<M-S-c>", "<C-w><S-j>", opts)

-- Navigate splits.
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

keymap("n", "<C-Left>", "<C-w>h", opts)
keymap("n", "<C-Down>", "<C-w>j", opts)
keymap("n", "<C-Up>", "<C-w>k", opts)
keymap("n", "<C-Right>", "<C-w>l", opts)

-- Resize splits.
keymap("n", "<M-h>", ":vertical resize -1<CR>", opts)
keymap("n", "<M-j>", ":resize -1<CR>", opts)
keymap("n", "<M-k>", ":resize +1<CR>", opts)
keymap("n", "<M-l>", ":vertical resize +1<CR>", opts)

keymap("n", "<M-Left>", ":vertical resize -1<CR>", opts)
keymap("n", "<M-Down>", ":resize -1<CR>", opts)
keymap("n", "<M-Up>", ":resize +1<CR>", opts)
keymap("n", "<M-Right>", ":vertical resize +1<CR>", opts)

-- Tabs --

-- Open new tab.
keymap("n", "<C-a>", ":tabnew<CR>", opts)
-- Select next tab.
keymap("n", "<C-s>", "gT", opts)
-- Select previous tab.
keymap("n", "<C-d>", "gt", opts)
-- Close current tab.
keymap("n", "<C-f>", ":tabclose<CR>", opts)

-- Buffers --

-- Open new buffer.
keymap("n", "<M-a>", ":enew<CR>", opts)
-- Select next buffer.
keymap("n", "<M-d>", ":bn<CR>", opts)
-- Select previous buffer.
keymap("n", "<M-s>", ":bp<CR>", opts)
-- Close current buffer.
keymap("n", "<M-f>", ":bd<CR>", opts)

-- Telescope --
keymap("n", "<leader>t", "<cmd>Telescope find_files<cr>", opts)
-- keymap("n", "<leader>t", "<cmd>lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({ previewer = false }))<cr>", opts)
keymap("n", "<leader>g", "<cmd>Telescope live_grep<cr>", opts)

-- Gitsigns --
keymap("n", "<leader>h", "<cmd>Gitsigns prev_hunk<cr>", opts)
keymap("n", "<leader>j", "<cmd>Gitsigns next_hunk<cr>", opts)
keymap("n", "<leader>k", "<cmd>Gitsigns preview_hunk<cr>", opts)

-- Nvimtree --
keymap("n", "<C-n>", ":NvimTreeToggle<cr>", opts)

keymap("", "<C-t>", ":ToggleTerm", opts)

-- Debugging --
keymap("n", "<leader>p", ":DapToggleBreakpoint<CR>", opts)
keymap("n", "<leader>c", ":DapContinue<CR>", opts)
keymap("n", "<leader>o", ":DapStepOver<CR>", opts)
keymap("n", "<leader>i", ":DapStepInto<CR>", opts)
