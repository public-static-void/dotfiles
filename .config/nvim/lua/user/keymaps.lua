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

vim.cmd("cabbrev Q q")
vim.cmd("cabbrev W w")

vim.cmd("cabbrev WQ wq")
vim.cmd("cabbrev Wq wq")
vim.cmd("cabbrev wQ wq")

vim.cmd("cabbrev qw wq")
vim.cmd("cabbrev qW wq")
vim.cmd("cabbrev Qw wq")
vim.cmd("cabbrev QW wq")

vim.cmd("cabbrev qA qa")
vim.cmd("cabbrev QA qa")
vim.cmd("cabbrev Qa qa")

-- Ex Mode is annoying. Use this for formatting instead.
keymap("n", "Q", "<Nop>", opts)

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

keymap("x", "<C-M-j>", ":m '>+1<CR>gv-gv", opts)
keymap("x", "<C-M-k>", ":m '<-2<CR>gv-gv", opts)

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
keymap("n", "<leader>t", ":Telescope find_files<cr>", opts)
-- keymap("n", "<leader>t", ":lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({ previewer = false }))<cr>", opts)
keymap("n", "<leader>g", ":Telescope live_grep<cr>", opts)

-- Gitsigns --
keymap("n", "<leader>h", ":Gitsigns prev_hunk<cr>", opts)
keymap("n", "<leader>j", ":Gitsigns next_hunk<cr>", opts)
keymap("n", "<leader>k", ":Gitsigns preview_hunk<cr>", opts)

-- Nvimtree --
keymap("n", "<C-n>", ":NvimTreeToggle<cr>", opts)

-- Debugging --
keymap("n", "<leader>p", ":DapToggleBreakpoint<CR>", opts)
keymap("n", "<leader>c", ":DapContinue<CR>", opts)
keymap("n", "<leader>o", ":DapStepOver<CR>", opts)
keymap("n", "<leader>i", ":DapStepInto<CR>", opts)

-- Java-specific
-- manually init debugger
keymap("n", "<leader>jd", "<Cmd>lua require('jdtls.dap').setup_dap_main_class_configs()<CR>", opts)

keymap("n", "<leader>jo", "<Cmd>lua require('jdtls').organize_imports()<CR>", opts)
keymap("n", "<leader>jv", "<Cmd>lua require('jdtls').extract_variable()<CR>", opts)
keymap("n", "<leader>jc", "<Cmd>lua require('jdtls').extract_constant()<CR>", opts)
keymap("n", "<leader>jt", "<Cmd>lua require('jdtls').test_nearest_method()<CR>", opts)
keymap("n", "<leader>jT", "<Cmd>lua require('jdtls').test_class()<CR>", opts)
keymap("n", "<leader>ju", "<Cmd>JdtUpdateConfig<CR>", opts)

keymap("v", "<leader>jv", "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>", opts)
keymap("v", "<leader>jc", "<Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>", opts)
keymap("v", "<leader>jm", "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>", opts)

-- LSP --
keymap("n", "<leader>f", ":lua vim.lsp.buf.format({async = true})<CR>", opts)
keymap("n", "<leader>n", ":lua vim.diagnostic.goto_next({ border = 'rounded' })<CR>", opts)
keymap("n", "<leader>b", ":lua vim.diagnostic.goto_prev({ border = 'rounded' })<CR>", opts)
keymap("n", "<leader>v", ":lua vim.diagnostic.setloclist()<CR>", opts)
keymap("n", "<TAB>", ":lua vim.lsp.buf.hover()<CR>", opts)
keymap("n", "gD", ":lua vim.lsp.buf.declaration()<CR>", opts)
keymap("n", "gd", ":lua vim.lsp.buf.definition()<CR>", opts)
keymap("n", "gi", ":lua vim.lsp.buf.implementation()<CR>", opts)
keymap("n", "gr", ":lua vim.lsp.buf.references()<CR>", opts)
keymap("n", "gs", ":lua vim.lsp.buf.signature_help()<CR>", opts)
keymap("n", "<leader>r", ":lua vim.lsp.buf.rename()<CR>", opts)
keymap("n", "<leader>a", ":lua vim.lsp.buf.code_action()<CR>", opts)
keymap("n", "<leader>m", ":lua vim.diagnostic.open_float()<CR>", opts)

keymap("n", "<Leader>s", ":lua require('neogen').generate()<CR>", opts)

-- Terminal --
keymap("", "<C-t>", ":ToggleTerm<CR>", opts)
keymap("t", "<C-t>", [[<C-\><C-n>:ToggleTerm<CR>]], opts)
keymap("t", "<esc>", [[<C-\><C-n>]], opts)
keymap("t", "<C-h>", [[<C-\><C-n><C-W>h]], opts)
keymap("t", "<C-j>", [[<C-\><C-n><C-W>j]], opts)
keymap("t", "<C-k>", [[<C-\><C-n><C-W>k]], opts)
keymap("t", "<C-l>", [[<C-\><C-n><C-W>l]], opts)
keymap("t", "<C-Left>", [[<C-\><C-n><C-W>h]], opts)
keymap("t", "<C-Down>", [[<C-\><C-n><C-W>j]], opts)
keymap("t", "<C-Up>", [[<C-\><C-n><C-W>k]], opts)
keymap("t", "<C-Right>", [[<C-\><C-n><C-W>l]], opts)

-- Other --

-- Place date and time string at current cursor position
keymap("n", "<leader>d", "i<C-R>=strftime('%c')<CR><ESC>", comm_opts)
-- Replace selection with date and time string
keymap("v", "<leader>d", "c<C-R>=strftime('%c')<CR><ESC>", comm_opts)

-- Shade
-- keymap("", "<leader>h", ":lua require('shade').toggle()<CR>", comm_opts)
-- keymap("", "<M-+>", ":lua require('shade').brightness_up()<CR>", comm_opts)
-- keymap("", "<M-->", ":lua require('shade').brightness_down()<CR>", comm_opts)




