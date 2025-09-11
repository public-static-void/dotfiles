local utils = require("user.utils")

local blink = utils.safe_require("blink.cmp")
if not blink then
	vim.notify("blink.cmp not found! Check your plugin setup.", vim.log.levels.ERROR)
	return
end

blink.setup({
	keymap = {
		preset = "enter",
		["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
		["<Tab>"] = { "snippet_forward", "select_next", "fallback" },
		["<Esc>"] = { "hide", "fallback" },
	},
	appearance = {
		nerd_font_variant = "Nerd Font Mono",
	},
	completion = {
		documentation = {
			auto_show = true,
		},
		ghost_text = {
			enabled = true,
		},
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
		},
		list = {
			selection = {
				preselect = false,
			},
		},
	},
	signature = {
		enabled = true,
	},
	sources = {
		default = { "lsp", "path", "snippets", "buffer", "codeium" },
		providers = {
			codeium = {
				name = "Codeium",
				module = "codeium.blink",
				async = true,
			},
		},
	},
	fuzzy = {
		implementation = "prefer_rust_with_warning",
	},
})
