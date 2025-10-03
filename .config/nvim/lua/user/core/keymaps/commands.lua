--- Command keymaps
--- @module user.keymaps.commands

-- Command abbreviations
vim.cmd([[
  cabbrev Q q
  cabbrev W w
  cabbrev WQ wq
  cabbrev Wq wq
  cabbrev wQ wq
  cabbrev qw wq
  cabbrev qW wq
  cabbrev Qw wq
  cabbrev QW wq
  cabbrev qA qa
  cabbrev QA qa
  cabbrev Qa qa
  cabbrev Q! q!
  cabbrev Qa! qa!
  cabbrev qA! qa!
  cabbrev QA! qa!
]])

-- Write with sudo (for protected files)
vim.keymap.set("c", "w!!", "w !sudo tee %", { noremap = true, silent = false, desc = "Write with sudo" })

-- Clear search highlighting
vim.keymap.set("n", "<ESC>", ":noh<CR><ESC>", { noremap = true, silent = true, desc = "Clear search highlight" })
