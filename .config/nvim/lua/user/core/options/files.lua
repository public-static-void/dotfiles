--- File and directory related options.
--- Ensures persistent undo, swap, spell directories exist.
--- Configures spell settings, wildignore patterns, and backup behavior.

local fs = require("user.utils.fs")
local uv = vim.loop
local opt = vim.opt

-- Automatically set working directory to that of the open buffer.
vim.opt.autochdir = true

-- Auto reload files changed outside Neovim.
vim.opt.autoread = true

-- Helper function: fallback join_path with vim.fs.joinpath or custom.
local function join_path(...)
	if vim.fs and vim.fs.joinpath then
		return vim.fs.joinpath(...)
	end
	local sep = package.config:sub(1, 1)
	return table.concat({ ... }, sep)
end

local data_path = vim.fn.stdpath("data")

local undodir = join_path(data_path, "undodir")
local swapdir = join_path(data_path, "swap")
local spell_dir = join_path(data_path, "spell")

-- Ensure that persistent directories exist.
local function create_dir_if_not_exists(dir)
	local stat = uv.fs_stat(dir)
	if not stat then
		local ok, err = uv.fs_mkdir(dir, 448) -- 0700 in decimal
		if not ok then
			vim.notify("Could not create directory: " .. dir .. "\nError: " .. (err or "unknown"), vim.log.levels.WARN)
		end
	end
end

create_dir_if_not_exists(undodir)
create_dir_if_not_exists(swapdir)
create_dir_if_not_exists(spell_dir)

-- Directory to store persistent undo files.
opt.undodir = undodir

-- Enable persistent undo.
opt.undofile = true

-- Directory to store swap files.
opt.directory = swapdir

-- Disable backup files (generally redundant with persistent undo).
opt.backup = false
opt.writebackup = false

-- Set default language for spell checking.
opt.spelllang = { "en" }

-- Disable spell checking by default.
opt.spell = false

-- Append file patterns to ignore during completion for performance.
opt.wildignore:append({
	"*/tmp/*",
	"*.so",
	"*.swp",
	"*.swo",
	"*.zip",
	".git",
	".cabal-sandbox",
	"*.docx",
	"*.jpg",
	"*.png",
	"*.gif",
	"*.pdf",
	"*.pyc",
	"*.exe",
	"*.flv",
	"*.img",
	"*.xlsx",
})

-- Suppress completion messages to reduce noise.
opt.shortmess:append("c")
