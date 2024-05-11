local colorscheme = "vscode"
-- local colorscheme = "darkplus"
-- local colorscheme = "codedark"
-- local colorscheme = "angr"
-- local colorscheme = "spacedark"
-- local colorscheme = "base16-da-one-gray"
-- local colorscheme = "base16-ia-dark"
-- local colorscheme = "pywal"

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
	vim.notify("colorscheme " .. colorscheme .. " not found!")
	return
end
