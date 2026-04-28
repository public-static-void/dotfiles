--- Plugin-specific keymaps for plugins like picker, flash, trouble, undotree, runner etc.
--- @module "user.keymaps.plugins"

local utils = require("user.utils")
local modules = {
	flash = utils.safe_require("flash"),
	picker = utils.safe_require("user.configs.ui.picker"),
	filetree = utils.safe_require("user.configs.ui.filetree"),
	runner = utils.safe_require("user.configs.project.coderunner"),
	dial = utils.safe_require("dial.map"),
}

for _, mod in pairs(modules) do
	if not mod then
		return
	end
end

local flash, picker, filetree, runner, dial =
	modules.flash, modules.picker, modules.filetree, modules.runner, modules.dial

vim.keymap.set({ "n", "x", "o" }, "S", function()
	flash.jump()
end, { noremap = true, silent = true, desc = "Jump" })

-- Picker
vim.keymap.set("n", "<leader>t", picker.find_files, { noremap = true, silent = true, desc = "Find files" })
vim.keymap.set("n", "<leader>g", picker.live_grep, { noremap = true, silent = true, desc = "Live grep" })
vim.keymap.set("n", "<M-z>", picker.buffers, { noremap = true, silent = true, desc = "Show Buffers" })
vim.keymap.set("n", "<leader>z", picker.tabs, { noremap = true, silent = true, desc = "Show Tabs" })
vim.keymap.set("n", "<leader>'", picker.marks, { noremap = true, silent = true, desc = "Show Marks" })
vim.keymap.set("n", '<leader>"', picker.registers, { noremap = true, silent = true, desc = "Show Registers" })

-- Filetree
vim.keymap.set("n", "<C-n>", filetree.toggle_tree, { noremap = true, silent = true, desc = "Toggle File Tree" })

-- Git Signs
vim.keymap.set("n", "<leader>h", ":Gitsigns prev_hunk<cr>", { noremap = true, silent = true, desc = "Previous hunk" })
vim.keymap.set("n", "<leader>j", ":Gitsigns next_hunk<cr>", { noremap = true, silent = true, desc = "Next hunk" })
vim.keymap.set("n", "<leader>k", ":Gitsigns preview_hunk<cr>", { noremap = true, silent = true, desc = "Preview hunk" })

-- DAP
vim.keymap.set(
	"n",
	"<leader>p",
	":DapToggleBreakpoint<CR>",
	{ noremap = true, silent = true, desc = "DAP: Toggle breakpoint" }
)
vim.keymap.set("n", "<leader>c", ":DapContinue<CR>", { noremap = true, silent = true, desc = "DAP: Continue" })
vim.keymap.set("n", "<leader>o", ":DapStepOver<CR>", { noremap = true, silent = true, desc = "DAP: Step over" })
vim.keymap.set("n", "<leader>i", ":DapStepInto<CR>", { noremap = true, silent = true, desc = "DAP: Step into" })

-- Undo Tree
vim.keymap.set("n", "<leader>u", ":Undotree<CR>", { noremap = true, silent = true, desc = "Toggle UndoTree" })

-- Aerial
vim.keymap.set("n", "<C-m>", ":AerialToggle<CR>", { noremap = true, silent = true, desc = "Toggle Aerial" })

-- Runner
vim.keymap.set("n", "<leader>e", runner.run_file, { noremap = true, silent = false, desc = "Run current File" })

-- Dial
vim.keymap.set("n", "<C-a>", function()
	dial.manipulate("increment", "normal")
end, { noremap = true, silent = true, desc = "Dial increment" })

vim.keymap.set("n", "<C-x>", function()
	dial.manipulate("decrement", "normal")
end, { noremap = true, silent = true, desc = "Dial decrement" })

vim.keymap.set("n", "g<C-a>", function()
	dial.manipulate("increment", "gnormal")
end, { noremap = true, silent = true, desc = "Dial g-increment" })

vim.keymap.set("n", "g<C-x>", function()
	dial.manipulate("decrement", "gnormal")
end, { noremap = true, silent = true, desc = "Dial g-decrement" })

vim.keymap.set("x", "<C-a>", function()
	dial.manipulate("increment", "visual", "visual")
end, { noremap = true, silent = true, desc = "Dial visual increment" })

vim.keymap.set("x", "<C-x>", function()
	dial.manipulate("decrement", "visual", "visual")
end, { noremap = true, silent = true, desc = "Dial visual decrement" })
