local opts = { noremap = true, silent = true }
local comm_opts = { noremap = true, silent = false }

vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- Commands (cabbrev)
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
]])

-- Ex Mode is annoying. Use this for formatting instead.
vim.keymap.set("n", "Q", "<Nop>", { noremap = true, silent = true, desc = "Disable Ex mode" })

-- Enable to edit protected files.
vim.keymap.set("c", "w!!", "w !sudo tee %", { noremap = true, silent = false, desc = "Write with sudo" })

-- Remove last search highlighting.
vim.keymap.set("n", "<ESC>", ":noh<CR><ESC>", { noremap = true, silent = true, desc = "Clear search highlight" })

-- Registers --
vim.keymap.set("v", "p", '"_dP', { noremap = true, silent = true, desc = "Paste without overwriting register" })
vim.keymap.set("x", "p", "pgvy", { noremap = true, silent = true, desc = "Paste and reselect in visual mode" })
vim.keymap.set("v", "y", "ygv<Esc>", { noremap = true, silent = true, desc = "Yank and reselect in visual mode" })

-- Navigation --
vim.keymap.set({ "n", "v", "o" }, "<S-h>", "0", { noremap = true, silent = true, desc = "Go to line start" })
vim.keymap.set({ "n", "v", "o" }, "<S-l>", "$", { noremap = true, silent = true, desc = "Go to line end" })
vim.keymap.set({ "n", "v", "o" }, "<S-j>", "G", { noremap = true, silent = true, desc = "Go to file end" })
vim.keymap.set({ "n", "v", "o" }, "<S-k>", "gg", { noremap = true, silent = true, desc = "Go to file start" })

vim.keymap.set({ "n", "v", "o" }, "<S-Left>", "0", { noremap = true, silent = true, desc = "Go to line start" })
vim.keymap.set({ "n", "v", "o" }, "<S-Right>", "$", { noremap = true, silent = true, desc = "Go to line end" })
vim.keymap.set({ "n", "v", "o" }, "<S-Down>", "G", { noremap = true, silent = true, desc = "Go to file end" })
vim.keymap.set({ "n", "v", "o" }, "<S-Up>", "gg", { noremap = true, silent = true, desc = "Go to file start" })

vim.keymap.set({ "n", "v" }, "j", "gj", { noremap = true, silent = true, desc = "Move down (visual line)" })
vim.keymap.set({ "n", "v" }, "k", "gk", { noremap = true, silent = true, desc = "Move up (visual line)" })
vim.keymap.set({ "n", "v" }, "<Down>", "gj", { noremap = true, silent = true, desc = "Move down (visual line)" })
vim.keymap.set({ "n", "v" }, "<Up>", "gk", { noremap = true, silent = true, desc = "Move up (visual line)" })
vim.keymap.set("i", "<Down>", "<C-o>gj", { noremap = true, silent = true, desc = "Move down (visual line)" })
vim.keymap.set("i", "<Up>", "<C-o>gk", { noremap = true, silent = true, desc = "Move up (visual line)" })

vim.keymap.set("v", "<", "<gv", { noremap = true, silent = true, desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { noremap = true, silent = true, desc = "Indent right and reselect" })

-- Move text up and down.
vim.keymap.set("n", "<C-M-j>", ":m .+1<CR>==", { noremap = true, silent = true, desc = "Move line down" })
vim.keymap.set("n", "<C-M-k>", ":m .-2<CR>==", { noremap = true, silent = true, desc = "Move line up" })
vim.keymap.set("v", "<C-M-j>", ":m .+1<CR>==", { noremap = true, silent = true, desc = "Move selection down" })
vim.keymap.set("v", "<C-M-k>", ":m .-2<CR>==", { noremap = true, silent = true, desc = "Move selection up" })
vim.keymap.set("x", "<C-M-j>", ":m '>+1<CR>gv-gv", { noremap = true, silent = true, desc = "Move block down" })
vim.keymap.set("x", "<C-M-k>", ":m '<-2<CR>gv-gv", { noremap = true, silent = true, desc = "Move block up" })

-- Splits --
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

-- Tabs --
vim.keymap.set("n", "<C-a>", ":tabnew<CR>", { noremap = true, silent = true, desc = "New tab" })
vim.keymap.set("n", "<C-s>", "gT", { noremap = true, silent = true, desc = "Previous tab" })
vim.keymap.set("n", "<C-d>", "gt", { noremap = true, silent = true, desc = "Next tab" })
vim.keymap.set("n", "<C-f>", ":tabclose<CR>", { noremap = true, silent = true, desc = "Close tab" })

-- Buffers --
vim.keymap.set("n", "<M-a>", ":enew<CR>", { noremap = true, silent = true, desc = "New buffer" })
vim.keymap.set("n", "<M-d>", ":bn<CR>", { noremap = true, silent = true, desc = "Next buffer" })
vim.keymap.set("n", "<M-s>", ":bp<CR>", { noremap = true, silent = true, desc = "Previous buffer" })
vim.keymap.set("n", "<M-f>", ":bd<CR>", { noremap = true, silent = true, desc = "Delete buffer" })
vim.keymap.set("n", "<M-g>", ":Bdelete<CR>", { noremap = true, silent = true, desc = "Force delete buffer" })

-- Telescope --
vim.keymap.set(
	"n",
	"<leader>t",
	":Telescope find_files<cr>",
	{ noremap = true, silent = true, desc = "Find files (Telescope)" }
)
vim.keymap.set(
	"n",
	"<leader>g",
	":Telescope live_grep<cr>",
	{ noremap = true, silent = true, desc = "Live grep (Telescope)" }
)
vim.keymap.set(
	"n",
	"<leader>z",
	":Telescope buffers<cr>",
	{ noremap = true, silent = true, desc = "Buffers (Telescope)" }
)

-- Gitsigns --
vim.keymap.set(
	"n",
	"<leader>h",
	":Gitsigns prev_hunk<cr>",
	{ noremap = true, silent = true, desc = "Previous hunk (Gitsigns)" }
)
vim.keymap.set(
	"n",
	"<leader>j",
	":Gitsigns next_hunk<cr>",
	{ noremap = true, silent = true, desc = "Next hunk (Gitsigns)" }
)
vim.keymap.set(
	"n",
	"<leader>k",
	":Gitsigns preview_hunk<cr>",
	{ noremap = true, silent = true, desc = "Preview hunk (Gitsigns)" }
)

-- Nvimtree --
vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<cr>", { noremap = true, silent = true, desc = "Toggle NvimTree" })

-- Aerial --
vim.keymap.set(
	"n",
	"<C-m>",
	"<cmd>AerialToggle!<CR>",
	{ noremap = true, silent = true, desc = "Toggle Aerial outline" }
)

-- Debugging --
vim.keymap.set(
	"n",
	"<leader>p",
	":DapToggleBreakpoint<CR>",
	{ noremap = true, silent = true, desc = "DAP: Toggle breakpoint" }
)
vim.keymap.set("n", "<leader>c", ":DapContinue<CR>", { noremap = true, silent = true, desc = "DAP: Continue" })
vim.keymap.set("n", "<leader>o", ":DapStepOver<CR>", { noremap = true, silent = true, desc = "DAP: Step over" })
vim.keymap.set("n", "<leader>i", ":DapStepInto<CR>", { noremap = true, silent = true, desc = "DAP: Step into" })

-- LSP --
vim.keymap.set("n", "<leader>f", function()
	vim.lsp.buf.format({ async = true })
end, { noremap = true, silent = true, desc = "LSP: Format buffer" })
vim.keymap.set(
	"n",
	"<leader>n",
	vim.diagnostic.goto_next,
	{ noremap = true, silent = true, desc = "LSP: Next diagnostic" }
)
vim.keymap.set(
	"n",
	"<leader>b",
	vim.diagnostic.goto_prev,
	{ noremap = true, silent = true, desc = "LSP: Previous diagnostic" }
)
vim.keymap.set("n", "<leader>v", function()
	local ok, trouble = pcall(require, "trouble")
	if ok and trouble then
		trouble.toggle("diagnostics")
	else
		vim.diagnostic.setloclist()
	end
end, { noremap = true, silent = true, desc = "LSP: Diagnostics (Trouble/loclist)" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { noremap = true, silent = true, desc = "LSP: Hover" })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { noremap = true, silent = true, desc = "LSP: Go to declaration" })
vim.keymap.set("n", "gd", function()
	local ok, trouble = pcall(require, "trouble")
	if ok and trouble then
		trouble.toggle("lsp_definitions")
	else
		vim.lsp.buf.definition()
	end
end, { noremap = true, silent = true, desc = "LSP: Go to definition (Trouble)" })
vim.keymap.set("n", "gi", function()
	local ok, trouble = pcall(require, "trouble")
	if ok and trouble then
		trouble.toggle("lsp_implementations")
	else
		vim.lsp.buf.implementation()
	end
end, { noremap = true, silent = true, desc = "LSP: Go to implementation (Trouble)" })
vim.keymap.set("n", "gr", function()
	local ok, trouble = pcall(require, "trouble")
	if ok and trouble then
		trouble.toggle("lsp_references")
	else
		vim.lsp.buf.references()
	end
end, { noremap = true, silent = true, desc = "LSP: References (Trouble)" })
vim.keymap.set("n", "<leader>q", function()
	local ok, trouble = pcall(require, "trouble")
	if ok and trouble then
		trouble.toggle("quickfix")
	else
		vim.cmd("copen")
	end
end, { noremap = true, silent = true, desc = "Quickfix list (Trouble)" })
vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, { noremap = true, silent = true, desc = "LSP: Signature help" })
vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, { noremap = true, silent = true, desc = "LSP: Rename symbol" })
vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, { noremap = true, silent = true, desc = "LSP: Code action" })
vim.keymap.set(
	"n",
	"<leader>m",
	vim.diagnostic.open_float,
	{ noremap = true, silent = true, desc = "LSP: Show diagnostic float" }
)
vim.keymap.set("n", "<Leader>s", function()
	local ok, neogen = pcall(require, "neogen")
	if ok and neogen then
		neogen.generate()
	else
		vim.notify("Neogen not found!", vim.log.levels.WARN)
	end
end, { noremap = true, silent = true, desc = "Generate docstring (Neogen)" })

-- Terminal --
vim.keymap.set("n", "<C-t>", ":ToggleTerm<CR>", { noremap = true, silent = true, desc = "Toggle terminal" })
vim.keymap.set("t", "<C-t>", [[<C-\><C-n>:ToggleTerm<CR>]], { noremap = true, silent = true, desc = "Toggle terminal" })
vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], { noremap = true, silent = true, desc = "Terminal normal mode" })
vim.keymap.set(
	"t",
	"<C-h>",
	[[<C-\><C-n><C-W>h]],
	{ noremap = true, silent = true, desc = "Terminal: Move to left window" }
)
vim.keymap.set(
	"t",
	"<C-j>",
	[[<C-\><C-n><C-W>j]],
	{ noremap = true, silent = true, desc = "Terminal: Move to lower window" }
)
vim.keymap.set(
	"t",
	"<C-k>",
	[[<C-\><C-n><C-W>k]],
	{ noremap = true, silent = true, desc = "Terminal: Move to upper window" }
)
vim.keymap.set(
	"t",
	"<C-l>",
	[[<C-\><C-n><C-W>l]],
	{ noremap = true, silent = true, desc = "Terminal: Move to right window" }
)
vim.keymap.set(
	"t",
	"<C-Left>",
	[[<C-\><C-n><C-W>h]],
	{ noremap = true, silent = true, desc = "Terminal: Move to left window" }
)
vim.keymap.set(
	"t",
	"<C-Down>",
	[[<C-\><C-n><C-W>j]],
	{ noremap = true, silent = true, desc = "Terminal: Move to lower window" }
)
vim.keymap.set(
	"t",
	"<C-Up>",
	[[<C-\><C-n><C-W>k]],
	{ noremap = true, silent = true, desc = "Terminal: Move to upper window" }
)
vim.keymap.set(
	"t",
	"<C-Right>",
	[[<C-\><C-n><C-W>l]],
	{ noremap = true, silent = true, desc = "Terminal: Move to right window" }
)

-- Undotree --
vim.keymap.set("n", "<leader>u", function()
	local ok, undotree = pcall(require, "undotree")
	if ok and undotree then
		undotree.toggle()
	else
		vim.notify("Undotree not found!", vim.log.levels.WARN)
	end
end, { noremap = true, silent = true, desc = "Toggle UndoTree" })

-- Other --
local datetime = tostring(os.date("%a %b %d %H:%M:%S %Y %z"))
vim.keymap.set("n", "<leader>d", function()
	vim.api.nvim_put({ datetime }, "c", false, true)
end, { noremap = true, silent = false, desc = "Insert current datetime" })
vim.keymap.set("v", "<leader>d", function()
	vim.api.nvim_put({ datetime }, "c", true, true)
end, { noremap = true, silent = false, desc = "Insert current datetime" })
