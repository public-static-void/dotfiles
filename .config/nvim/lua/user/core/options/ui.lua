--- UI-related Neovim options.
--- Includes colors, line numbering, cursor, folding, and other display settings.

local opt = vim.opt

-- Internal file encoding used by Neovim.
vim.opt.encoding = "utf-8"

-- Encodings tried on file read for automatic file encoding detection.
vim.opt.fileencodings = "utf-8,ucs-bom,latin1"

-- Disable modelines to prevent execution of modeline code on file open.
vim.opt.modelines = 0
vim.opt.modeline = false

-- Do not show the current mode ("-- INSERT --") since statusline handles it.
vim.opt.showmode = false

-- Enable mouse support in all modes.
vim.opt.mouse = "a"

-- Allow cursor to move one character past end of line.
vim.opt.virtualedit = "onemore"

-- Enable 24-bit RGB color in terminal UI.
opt.termguicolors = true

-- Show the file name in the terminal/window title.
opt.title = true

-- Show absolute line numbers.
opt.number = true

-- Show relative line numbers to the cursor.
opt.relativenumber = true

-- Display line and column number in the status line.
opt.ruler = true

-- Always show the tab line (tabs bar).
opt.showtabline = 2

-- Highlight the line under the cursor.
opt.cursorline = true

-- Keep one line visible above and below the cursor when scrolling.
opt.scrolloff = 1

-- Always show the sign column (used by diagnostics, git, etc.).
opt.signcolumn = "yes"

-- Use rounded borders on floating windows.
opt.winborder = "rounded"

-- Highlight matching parentheses or brackets when cursor is nearby.
opt.showmatch = true

-- Show incomplete command in the status line.
opt.showcmd = true

-- Show tabs and trailing spaces visually.
opt.list = true

-- Define characters to show for tabs and trailing spaces.
opt.listchars = "tab:>·,trail:·"

-- Specify fold settings: use Treesitter by default.
opt.foldlevelstart = 20
opt.foldenable = true

-- Enable new UI
require("vim._core.ui2").enable({})
