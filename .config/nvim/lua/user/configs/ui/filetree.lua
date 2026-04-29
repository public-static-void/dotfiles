local utils = require("user.utils")

local neo_tree = utils.safe_require("neo-tree")
if not neo_tree then
	return
end

local neo_tree_cmd = utils.safe_require("neo-tree.command")
if not neo_tree_cmd then
	return
end

local ipairs = ipairs

neo_tree.setup({
	close_if_last_window = false,
	popup_border_style = "",
	enable_git_status = true,
	enable_diagnostics = true,
	open_files_do_not_replace_types = { "terminal", "trouble", "qf" },
	default_component_configs = {
		indent = {
			indent_size = 2,
			padding = 1,
		},
		icon = {
			folder_closed = "",
			folder_open = "",
			folder_empty = "",
			default = "",
		},
		git_status = {
			symbols = {
				added = "+",
				modified = "~",
				deleted = "-",
				renamed = "➜",
				untracked = "?",
				ignored = "◌",
				unstaged = "!",
				staged = "✓",
				conflict = "",
			},
		},
		modified = {
			symbol = "[+]",
			highlight = "NeoTreeModified",
		},
	},
	filesystem = {
		follow_current_file = {
			enabled = true,
		},
		use_libuv_file_watcher = true,
		filtered_items = {
			visible = true,
			hide_dotfiles = false,
			hide_gitignored = false,
			never_show = { ".git", "node_modules", ".cache" },
		},
	},
	window = {
		position = "left",
		width = 30,
		mappings = {
			["<cr>"] = "open",
			["a"] = "add",
			["d"] = "delete",
			["r"] = "rename",
			["b"] = "rename_basename", -- rename basename only, inline
			["y"] = "copy_to_clipboard", -- copy file path
			["x"] = "cut_to_clipboard", -- cut file path
			["p"] = "paste_from_clipboard", -- paste file/folder from clipboard
			["h"] = "toggle_hidden", -- toggle hidden files/dotfiles
			["R"] = "refresh", -- refresh Neo-tree
			["?"] = "show_help", -- show help
			["<space>"] = "noop",
		},
	},
})

local M = {}

-- Toggle Neo-tree sidebar on filesystem source
function M.toggle_tree()
	vim.schedule(function()
		local is_open = false
		local current_tab = vim.api.nvim_get_current_tabpage()
		for _, win in ipairs(vim.api.nvim_tabpage_list_wins(current_tab)) do
			local buf = vim.api.nvim_win_get_buf(win)
			if vim.bo[buf].filetype == "neo-tree" then
				is_open = true
				break
			end
		end
		if is_open then
			neo_tree_cmd.execute({ action = "close" })
		else
			neo_tree_cmd.execute({ action = "focus", source = "filesystem", reveal = true })
		end
	end)
end

return M
