-- Improve startup time.
vim.loader.enable()

local options = {

	-- Set encoding to UTF-8.
	encoding = "utf-8",
	fileencodings = "utf-8,ucs-bom,latin1",

	-- Enables 24-bit RBG colors in the TUI. Uses "gui" :highlight instead of "cterm".
	termguicolors = true,

	-- Increase update times from default 4s.
	updatetime = 100,

	-- Set current directory to file location.
	autochdir = true,

	-- Watch for file changes.
	autoread = true,

	-- Enable system clipboard for copy/paste from/to outside vim.
	clipboard = "unnamed,unnamedplus",

	-- Show the file name in the terminal title bar.
	title = true,

	-- Enable line numbers.
	number = true,
	relativenumber = true,

	-- Show row and column information.
	ruler = true,

	-- Always show tabs-bar.
	showtabline = 2,

	-- Disable modelines as a security precaution.
	modelines = 0,
	modeline = false,

	-- Don't show mode.
	showmode = false,

	-- Highlight cursor line.
	cursorline = true,

	-- Keep one line below cursor when scrolling.
	scrolloff = 1,

	-- Allow mouse scrolling and text selection.
	mouse = "a",

	-- Allow for cursor beyond last character.
	virtualedit = "onemore",

	-- Enable linebreak.
	linebreak = true,
	-- Show '+++' at beginning of broken line.
	showbreak = "+++",

	-- Enable autoindent.
	autoindent = true,
	-- Enable C-indent.
	smartindent = true,
	-- Set smartindent.
	smarttab = true,
	-- Convert tab to spaces.
	expandtab = true,
	-- Amount of spaces for tab.
	softtabstop = 2,
	tabstop = 2,
	-- Amount of spaces for autoindent.
	shiftwidth = 2,

	-- Show hidden characters.
	list = true,
	-- But only tabs and trailing whitespace.
	listchars = "tab:>·,trail:·",

	-- Enable incremental search.
	incsearch = true,
	-- Highlight the found search terms.
	hlsearch = true,

	-- If search term contains uppercase characters, do a case sensitive search.
	ignorecase = true,
	-- Else, ignore cases.
	smartcase = true,

	-- Show matching brackets.
	showmatch = true,

	-- Show incomplete commands.
	showcmd = true,

	-- Keep 1 line below status bar.
	cmdheight = 2,

	-- Completion options suggested by cmp-plugin.
	completeopt = { "menu", "menuone", "noselect" },

	-- Enables Tab-completion for the command line.
	wildmenu = true,
	-- First <Tab> will complete to the longest common string. Next <Tab> it will complete the first alternative and will start to cycle through the rest.
	wildmode = "longest:full,full",

	-- Splits open at the bottom and right.
	splitbelow = true,
	splitright = true,

	-- Set undo directory.
	undodir = vim.fn.stdpath("data") .. package.config:sub(1, 1) .. "undodir",
	-- Keep track of all undos globally in this directory only.
	undofile = true,

	-- Set backup directory.
	directory = vim.fn.stdpath("data") .. package.config:sub(1, 1) .. "swap",
	-- Delete local backup since everything is stored centrally.
	backup = false,
	writebackup = false,

	-- Always show the signcolumn (where diagnostics etc. appear).
	signcolumn = "yes",

	-- Set the window border style.
	winborder = "rounded",
}

-- Apply the options to Neovim.
for k, v in pairs(options) do
	vim.opt[k] = v
end

-- Create necessary directories for undo and swap files if they don't exist.
local function create_dir_if_not_exists(dir)
	if not vim.fn.isdirectory(dir) then
		vim.fn.mkdir(dir, "p", "0700")
	end
end
create_dir_if_not_exists(vim.fn.stdpath("data") .. package.config:sub(1, 1) .. "undodir")
create_dir_if_not_exists(vim.fn.stdpath("data") .. package.config:sub(1, 1) .. "swap")

-- Ignore certain folders/filetypes in the wildmenu.
vim.opt.wildignore:append(
	"*/tmp/*,*.so,*.swp,*.swo,*.zip,.git,.cabal-sandbox,*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx"
)

-- Don't pass messages to |ins-completion-menu|.
vim.opt.shortmess:append("c")

-- Allow specified keys that move the cursor left/right to move to the previous/next line when the cursor is on the first/last character in the line.
vim.cmd("set whichwrap+=<,>,[,],h,l")

-- Treat compound words connected with "-" as single words.
vim.cmd("set iskeyword+=-")

-- Set Neovim Python 3 provider path dynamically
local python3 = vim.fn.exepath("python3")
if python3 == "" then
	python3 = vim.fn.exepath("python")
end
if python3 ~= "" then
	vim.g.python3_host_prog = python3
end

-- Set Perl provider path dynamically
local perl = vim.fn.exepath("perl")
if perl ~= "" then
	vim.g.perl_host_prog = perl
end
