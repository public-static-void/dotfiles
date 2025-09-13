--- Buffer navigation and manipulation keymaps
--- @module user.keymaps.buffers

vim.keymap.set("n", "<M-Tab>", ":bn<CR>", { noremap = true, silent = true, desc = "Next buffer" })
vim.keymap.set("n", "<M-S-Tab>", ":bp<CR>", { noremap = true, silent = true, desc = "Previous buffer" })
vim.keymap.set("n", "<M-w>", ":enew<CR>", { noremap = true, silent = true, desc = "New buffer" })

vim.keymap.set("n", "<M-q>", function()
	if vim.fn.exists(":Bdelete") == 2 then
		return ":Bdelete!<CR>"
	else
		return ":bd!<CR>"
	end
end, {
	expr = true,
	replace_keycodes = true,
	noremap = true,
	silent = true,
	desc = "Delete buffer",
})

for i = 1, 9 do
	vim.keymap.set(
		"n",
		"<A-" .. i .. ">",
		":buffer " .. i .. "<CR>",
		{ noremap = true, silent = true, desc = "Go to buffer " .. i }
	)
end
