--- Editing behavior options.
--- Handles indentation, wrapping, clipboard integration, and search behavior.

local opt = vim.opt

-- Convert typed tabs into spaces.
opt.expandtab = true

-- Number of spaces inserted when pressing Tab.
opt.softtabstop = 2

-- Number of spaces a Tab character represents.
opt.tabstop = 2

-- Number of spaces to use for each step of auto-indent.
opt.shiftwidth = 2

-- Copy indentation from previous line on new line.
opt.autoindent = true

-- Enable smart indentation suited for C-like languages.
opt.smartindent = true

-- Enable smart behavior of the tab key.
opt.smarttab = true

-- Break lines at word boundaries when wrapping.
opt.linebreak = true

-- Show a '+++' marker at the start of wrapped lines.
opt.showbreak = "+++"

-- Use system clipboard for all yank, delete, change, put operations.
opt.clipboard = "unnamed,unnamedplus"

-- Highlight matches progressively while searching.
opt.incsearch = true

-- Highlight all matches of current search pattern.
opt.hlsearch = true

-- Ignore case during searching unless search contains uppercase letters.
opt.ignorecase = true

-- Enable smart case search override.
opt.smartcase = true

-- Enable command-line completion menu.
opt.wildmenu = true

-- Configure wildmenu to complete longest string first, then cycle through matches.
opt.wildmode = "longest:full,full"

-- Completion options to improve completion popup behavior.
vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- Open horizontal splits below the current window for natural positioning.
vim.opt.splitbelow = true

-- Open vertical splits to the right of the current window.
vim.opt.splitright = true

-- Allow cursor keys and h, l to wrap to previous/next line when crossing line start/end.
vim.cmd("set whichwrap+=<,>,[,],h,l")

-- Treat words connected by hyphen as single words for motions and searches.
vim.cmd("set iskeyword+=-")
