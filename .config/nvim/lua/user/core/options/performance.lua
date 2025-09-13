--- Performance-related Neovim options.
--- Improves startup time and UI responsiveness by enabling Lua loader and tweaking updates.

local opt = vim.opt

-- Improve startup time by enabling Lua module loader.
vim.loader.enable()

-- Time in ms for CursorHold and related events. Lower means more responsive UI.
opt.updatetime = 100

-- Command line height in lines, allows more message space.
opt.cmdheight = 2
