local utils = require("user.utils")

local telescope = utils.safe_require("telescope")
if not telescope then
	return
end

local actions = utils.safe_require("telescope.actions")
if not actions then
	return
end

local extensions_to_load = { "fzf", "ui-select", "telescope-tabs" }

telescope.setup({
	defaults = {
		prompt_prefix = " ",
		selection_caret = " ",
		path_display = { "smart" },
		file_ignore_patterns = {
			"node_modules/",
			".git/",
			".venv/",
			"vendor/",
			"target/",
			"%.lock",
			"%.pyc",
			"__pycache__/",
			"Downloads",
		},
		layout_strategy = "flex",
		layout_config = {
			horizontal = { preview_width = 0.55 },
			vertical = { width = 0.5 },
		},
		sorting_strategy = "ascending",
		winblend = 10,
		mappings = {
			i = {
				["<C-n>"] = actions.cycle_history_next,
				["<C-p>"] = actions.cycle_history_prev,
				["<C-c>"] = actions.close,
				["<Down>"] = actions.move_selection_next,
				["<Up>"] = actions.move_selection_previous,
				["<CR>"] = actions.select_default,
				["<C-b>"] = actions.select_horizontal,
				["<C-v>"] = actions.select_vertical,
				["<C-t>"] = actions.select_tab,
				["<C-Up>"] = actions.preview_scrolling_up,
				["<C-Down>"] = actions.preview_scrolling_down,
				["<PageUp>"] = actions.results_scrolling_up,
				["<PageDown>"] = actions.results_scrolling_down,
				["<Tab>"] = function(bufnr)
					actions.toggle_selection(bufnr)
					actions.move_selection_worse(bufnr)
				end,
				["<S-Tab>"] = function(bufnr)
					actions.toggle_selection(bufnr)
					actions.move_selection_better(bufnr)
				end,
				["<C-q>"] = function(bufnr)
					actions.send_to_qflist(bufnr)
					actions.open_qflist(bufnr)
				end,
				["<M-q>"] = function(bufnr)
					actions.send_selected_to_qflist(bufnr)
					actions.open_qflist(bufnr)
				end,
				["<C-l>"] = actions.complete_tag,
				["<C-h>"] = actions.which_key,
			},
			n = {
				["<esc>"] = actions.close,
				["<CR>"] = actions.select_default,
				["<C-b>"] = actions.select_horizontal,
				["<C-v>"] = actions.select_vertical,
				["<C-t>"] = actions.select_tab,
				["<Tab>"] = function(bufnr)
					actions.toggle_selection(bufnr)
					actions.move_selection_worse(bufnr)
				end,
				["<S-Tab>"] = function(bufnr)
					actions.toggle_selection(bufnr)
					actions.move_selection_better(bufnr)
				end,
				["<C-q>"] = function(bufnr)
					actions.send_to_qflist(bufnr)
					actions.open_qflist(bufnr)
				end,
				["<M-q>"] = function(bufnr)
					actions.send_selected_to_qflist(bufnr)
					actions.open_qflist(bufnr)
				end,
				["j"] = actions.move_selection_next,
				["k"] = actions.move_selection_previous,
				["H"] = actions.move_to_top,
				["M"] = actions.move_to_middle,
				["L"] = actions.move_to_bottom,
				["<Down>"] = actions.move_selection_next,
				["<Up>"] = actions.move_selection_previous,
				["gg"] = actions.move_to_top,
				["G"] = actions.move_to_bottom,
				["<C-Up>"] = actions.preview_scrolling_up,
				["<C-Down>"] = actions.preview_scrolling_down,
				["<PageUp>"] = actions.results_scrolling_up,
				["<PageDown>"] = actions.results_scrolling_down,
				["?"] = actions.which_key,
			},
		},
	},
	pickers = {
		find_files = {
			theme = "ivy",
			previewer = true,
		},
		live_grep = {
			theme = "ivy",
			previewer = true,
		},
		buffers = {
			theme = "dropdown",
			previewer = false,
			sort_mru = true,
			ignore_current_buffer = false,
		},
		lsp_references = {
			theme = "ivy",
		},
	},
	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		},
		["ui-select"] = {
			require("telescope.themes").get_dropdown({}),
		},
	},
})

for _, ext in ipairs(extensions_to_load) do
	pcall(telescope.load_extension, ext)
end
