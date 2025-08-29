-- Improve startup time by enabling Lua module loader.
vim.loader.enable()

local uv = vim.loop

-- Helper function to create directories if they don't exist.
local function create_dir_if_not_exists(dir)
	local stat = uv.fs_stat(dir)
	if not stat then
		-- Create directory with 0700 permissions for privacy.
		local ok, err = uv.fs_mkdir(dir, 448) -- 448 decimal = 0700 octal
		if not ok then
			vim.notify("Could not create directory: " .. dir .. "\nError: " .. (err or "unknown"), vim.log.levels.WARN)
		end
	end
end

-- Base data directory for Neovim.
local data_path = vim.fn.stdpath("data")

-- Use Neovim's native path join for better cross-platform compatibility (requires Neovim 0.9+).
local function join_path(...)
	-- fallback if vim.fs.joinpath not available in your version
	if vim.fs and vim.fs.joinpath then
		return vim.fs.joinpath(...)
	else
		return table.concat({ ... }, package.config:sub(1, 1))
	end
end

local undodir = join_path(data_path, "undodir")
local swapdir = join_path(data_path, "swap")
local spell_dir = join_path(data_path, "spell")

-- Ensure that persistent directories exist.
create_dir_if_not_exists(undodir)
create_dir_if_not_exists(swapdir)
create_dir_if_not_exists(spell_dir)

local options = {
	-- Internal file encoding used by Neovim.
	encoding = "utf-8",

	-- Encodings tried on file read to detect file encoding.
	fileencodings = "utf-8,ucs-bom,latin1",

	-- Enable 24-bit RGB colors in terminal UI if supported.
	termguicolors = true,

	-- Time in ms for CursorHold and related events. Lower means more responsive UI.
	updatetime = 100,

	-- Automatically set working directory to that of the open buffer.
	autochdir = true,

	-- Auto reload files changed outside Neovim.
	autoread = true,

	-- Use system clipboard for all yank, delete, change, put operations.
	clipboard = "unnamed,unnamedplus",

	-- Show the file name in the terminal/window title.
	title = true,

	-- Show absolute line numbers.
	number = true,

	-- Show relative line numbers to the cursor.
	relativenumber = true,

	-- Display line and column number in the status line.
	ruler = true,

	-- Always show the tab line (tabs bar).
	showtabline = 2,

	-- Disable modelines to prevent execution of modeline code on file open.
	modelines = 0,
	modeline = false,

	-- Do not show the current mode ("-- INSERT --") in the status line.
	showmode = false,

	-- Highlight the line under the cursor.
	cursorline = true,

	-- Keep one line visible above and below the cursor when scrolling.
	scrolloff = 1,

	-- Enable mouse support in all modes.
	mouse = "a",

	-- Allow cursor to move one character past end of line.
	virtualedit = "onemore",

	-- Break lines at word boundaries when wrapping.
	linebreak = true,

	-- Show a '+++' marker at the start of wrapped lines.
	showbreak = "+++",

	-- Copy indentation from previous line when starting a new line.
	autoindent = true,

	-- Enable smart indentation suited for C-like languages.
	smartindent = true,

	-- Enable smart behaviour of the tab key.
	smarttab = true,

	-- Convert typed tabs into spaces.
	expandtab = true,

	-- Number of spaces inserted when pressing Tab.
	softtabstop = 2,

	-- Number of spaces a Tab character represents.
	tabstop = 2,

	-- Number of spaces to use for each step of auto-indent.
	shiftwidth = 2,

	-- Show tabs and trailing spaces visually.
	list = true,

	-- Define characters to show for tabs and trailing spaces.
	listchars = "tab:>·,trail:·",

	-- Highlight matches progressively while searching.
	incsearch = true,

	-- Highlight all matches of the current search pattern.
	hlsearch = true,

	-- Ignore case during searching unless search contains uppercase letters.
	ignorecase = true,
	smartcase = true,

	-- Highlight matching parentheses or brackets when cursor is nearby.
	showmatch = true,

	-- Show incomplete command in the status line.
	showcmd = true,

	-- Command line height in lines, allows more message space.
	cmdheight = 2,

	-- Completion options.
	completeopt = { "menu", "menuone", "noselect" },

	-- Enable command-line completion menu.
	wildmenu = true,

	-- Configure wildmenu to complete longest string first, then cycle through matches.
	wildmode = "longest:full,full",

	-- Open horizontal splits below the current window.
	splitbelow = true,

	-- Open vertical splits to the right of the current window.
	splitright = true,

	-- Directory to store persistent undo files.
	undodir = undodir,

	-- Enable persistent undo.
	undofile = true,

	-- Directory to store swap files.
	directory = swapdir,

	-- Disable backup files (generally redundant with persistent undo).
	backup = false,
	writebackup = false,

	-- Always show the sign column (used by diagnostics, git, etc.).
	signcolumn = "yes",

	-- Use rounded borders on floating windows.
	winborder = "rounded",

	-- Enable spell checking for specified languages.
	spelllang = { "de", "en" },

	-- Use custom spell additions file path.
	spellfile = join_path(spell_dir, "de.utf-8.add"),

	-- Enable spell checking by default.
	spell = true,

	-- Specify fold method
	-- foldmethod = "expr",

	-- Use treesitter for folding
	-- foldexpr = "nvim_treesitter#foldexpr()",

	-- Open folds by default
	foldlevelstart = 20,

	-- Enable folding
	foldenable = true,

  -- foldcolumn = "1",
}

-- Apply all options.
for k, v in pairs(options) do
	vim.opt[k] = v
end

-- Append file patterns to ignore during completion for performance.
vim.opt.wildignore:append({
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
vim.opt.shortmess:append("c")

-- Allow cursor keys and h, l to wrap to previous/next line when crossing line start/end.
vim.cmd("set whichwrap+=<,>,[,],h,l")

-- Treat words connected by hyphen as single words for motions and searches.
vim.cmd("set iskeyword+=-")

-- Autocommand: regenerate compiled spell file if the spell additions file changes,
-- triggered when Neovim gains focus, to keep spell checking up to date.
vim.api.nvim_create_autocmd("FocusGained", {
	pattern = "*",
	callback = function()
		local add_file = join_path(spell_dir, "de.utf-8.add")
		local spl_file = join_path(spell_dir, "de.utf-8.add.spl")
		if vim.fn.filereadable(add_file) == 1 then
			local add_mtime = vim.fn.getftime(add_file)
			local spl_mtime = vim.fn.getftime(spl_file)
			if add_mtime > spl_mtime or spl_mtime == -1 then
				vim.cmd("silent! mkspell! " .. spl_file .. " " .. add_file)
			end
		end
	end,
})

-- Dynamically detect Python 3 executable for Neovim Python provider.
local python3 = vim.fn.exepath("python3")
if python3 == "" then
	python3 = vim.fn.exepath("python")
end
if python3 ~= "" then
	vim.g.python3_host_prog = python3
end

-- Dynamically detect Perl executable for Neovim Perl provider.
local perl = vim.fn.exepath("perl")
if perl ~= "" then
	vim.g.perl_host_prog = perl
end

-- Dynamically detect Node executable for Neovim Node provider.
local node_host = vim.fn.exepath("neovim-node-host")
if node_host ~= "" then
	vim.g.node_host_prog = node_host
end
