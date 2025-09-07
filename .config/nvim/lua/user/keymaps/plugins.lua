--- Plugin-specific keymaps for plugins like picker, flash, trouble, undotree, runner etc.
--- @module user.keymaps.plugins

local utils = require("user.utils")
local modules = {
	flash = utils.safe_require("flash"),
	picker = utils.safe_require("user.ui.picker"),
	filetree = utils.safe_require("user.ui.filetree"),
	runner = utils.safe_require("user.project.coderunner"),
	undotree = utils.safe_require("undotree"),
}

for _, mod in pairs(modules) do
	if not mod then
		return
	end
end

local flash, picker, filetree, runner, undotree =
	modules.flash, modules.picker, modules.filetree, modules.runner, modules.undotree

vim.keymap.set({ "n", "x", "o" }, "S", function()
	flash.jump()
end, { noremap = true, silent = true, desc = "Jump" })

vim.keymap.set("n", "<leader>t", picker.find_files, { noremap = true, silent = true, desc = "Find files" })
vim.keymap.set("n", "<leader>g", picker.live_grep, { noremap = true, silent = true, desc = "Live grep" })
vim.keymap.set("n", "<M-z>", picker.buffers, { noremap = true, silent = true, desc = "Show Buffers" })
vim.keymap.set("n", "<leader>z", picker.tabs, { noremap = true, silent = true, desc = "Show Tabs" })

vim.keymap.set("n", "<C-n>", filetree.toggle_tree, { noremap = true, silent = true, desc = "Toggle File Tree" })

vim.keymap.set("n", "<leader>h", ":Gitsigns prev_hunk<cr>", { noremap = true, silent = true, desc = "Previous hunk" })
vim.keymap.set("n", "<leader>j", ":Gitsigns next_hunk<cr>", { noremap = true, silent = true, desc = "Next hunk" })
vim.keymap.set("n", "<leader>k", ":Gitsigns preview_hunk<cr>", { noremap = true, silent = true, desc = "Preview hunk" })

vim.keymap.set(
	"n",
	"<leader>p",
	":DapToggleBreakpoint<CR>",
	{ noremap = true, silent = true, desc = "DAP: Toggle breakpoint" }
)
vim.keymap.set("n", "<leader>c", ":DapContinue<CR>", { noremap = true, silent = true, desc = "DAP: Continue" })
vim.keymap.set("n", "<leader>o", ":DapStepOver<CR>", { noremap = true, silent = true, desc = "DAP: Step over" })
vim.keymap.set("n", "<leader>i", ":DapStepInto<CR>", { noremap = true, silent = true, desc = "DAP: Step into" })

vim.keymap.set("n", "<leader>u", function()
	undotree.toggle()
end, { noremap = true, silent = true, desc = "Toggle UndoTree" })

vim.keymap.set("n", "<leader>e", runner.run_file, { noremap = true, silent = false, desc = "Run current File" })
