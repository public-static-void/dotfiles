local utils = require("user.utils")

local blink = utils.safe_require("blink.cmp")
if not blink then
	vim.notify("blink.cmp not found! Check your plugin setup.", vim.log.levels.ERROR)
	return
end

local llm_server = utils.safe_require("user.configs.completion.llm_server")
if not llm_server then
	return
end

--- Returns whether the cursor is at the beginning of the line or the immediate
--- left-hand character is whitespace.
--- This helps determine if a completion menu should be triggered on <Tab>.
--- @return boolean True if cursor at line start or left char is whitespace; else false.
local function cursor_at_line_start_or_immediate_left_whitespace()
	local col = vim.fn.col(".") - 1
	if col == 0 then
		return true
	end
	local line = vim.fn.getline(".")
	local char = line:sub(col, col)
	return char:match("%s") ~= nil
end

--- Handles <Tab> keypress for blink.cmp behavior.
--- Shows completion menu only if the cursor is not at line start or
--- immediate left char is not whitespace.
--- @return nil|any Result of blink.show() when completion is triggered.
local function handle_tab()
	if cursor_at_line_start_or_immediate_left_whitespace() then
		return
	else
		return blink.show()
	end
end

--- Configures blink.cmp completion plugin with keymaps, appearance,
--- completion behavior, signature help, sources, and fuzzy-matching.
--- Designed for efficient, context-aware completion in Neovim.
blink.setup({
	keymap = {
		preset = "enter",
		["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
		["<Tab>"] = { "snippet_forward", "select_next", handle_tab, "fallback" },
		["<Esc>"] = { "hide", "fallback" },
	},
	appearance = {
		nerd_font_variant = "Nerd Font Mono",
	},
	completion = {
		documentation = { auto_show = true },
		ghost_text = { enabled = true },
		menu = {
			auto_show = false,
			draw = {
				columns = {
					{ "kind_icon" },
					{ "label", "label_description", gap = 1 },
					{ "source_name" },
				},
				components = {
					source_name = {
						width = { max = 30 },
						text = function(ctx)
							return "[" .. ctx.source_name .. "]"
						end,
						highlight = "BlinkCmpSource",
					},
				},
			},
		},
		trigger = {
			show_in_snippet = false,
			prefetch_on_insert = false,
		},
		list = { selection = { preselect = false } },
	},
	signature = { enabled = true },
	sources = {
		default = vim.tbl_filter(function(source)
			return source ~= "minuet" or llm_server.reachable()
		end, { "lsp", "path", "snippets", "buffer", "codeium", "minuet" }),
		providers = {
			codeium = {
				name = "Codeium",
				module = "codeium.blink",
				async = true,
			},
			minuet = llm_server.reachable() and {
				name = "minuet",
				module = "minuet.blink",
				async = true,
				score_offset = 50,
			} or nil,
		},
	},
	fuzzy = {
		implementation = "prefer_rust_with_warning",
	},
})
