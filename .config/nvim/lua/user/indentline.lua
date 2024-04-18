local status_ok, indent_blankline = pcall(require, "ibl")
if not status_ok then
	return
end

local hooks_status_ok, hooks = pcall(require, "ibl.hooks")
if not hooks_status_ok then
	return
end

local highlight = {
	"RainbowRed",
	"RainbowYellow",
	"RainbowBlue",
	"RainbowOrange",
	"RainbowGreen",
	"RainbowViolet",
	"RainbowCyan",
}

-- rainbow-delimiters.nvim integration
vim.g.rainbow_delimiters = { highlight = highlight }

hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
	vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
	vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
	vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
	vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
	vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
	vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
	vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
end)

indent_blankline.setup({
	enabled = true,
	exclude = {
		buftypes = {
			"nofile",
			"terminal",
		},
		filetypes = {
			"",
			"alpha",
			"big_file_disabled_ft",
			"dapui",
			"dashboard",
			"dbui",
			"dotooagenda",
			"floaterm",
			"flutterToolsOutline",
			"fugitive",
			"git",
			"gitcommit",
			"help",
			"json",
			"lazy",
			"log",
			"markdown",
			"mason",
			"neogit",
			"neogitstatus",
			"NvimTree",
			"Outline",
			"packer",
			"peekaboo",
			"startify",
			"TelescopePrompt",
			"text",
			"todoist",
			"Trouble",
			"txt",
			"undotree",
			"vimwiki",
			"vista",
		},
	},
	indent = {
		char = { "┊" },
		tab_char = { "╎" },
		highlight = highlight,
	},
	whitespace = {
		highlight = {
			"CursorColumn",
			"Function",
			"Label",
			"NonText",
			"Whitespace",
		},
		remove_blankline_trail = true,
	},
	scope = {
		enabled = true,
		char = "┃",
		show_start = false,
		show_end = false,
		highlight = highlight,
		include = {
			node_type = {
				["*"] = {
					"^expression",
					"^for",
					"^if",
					"^import",
					"^object",
					"^table",
					"^type",
					"^while",
					"argument_list",
					"arguments",
					"arrow_function",
					"assignment_statement",
					"block",
					"Block",
					"bracket",
					"catch_clause",
					"chunk",
					"class",
					"class_name",
					"const_declaration",
					"ContainerDecl",
					"declaration",
					"dictionary",
					"do_block",
					"do_statement",
					"element",
					"elif_clause",
					"else_clause",
					"except",
					"field",
					"field_declaration_list",
					"field_initializer_list",
					"FnCallArguments",
					"for",
					"for_in_statement",
					"for_statement",
					"func_literal",
					"function",
					"function_declaration",
					"function_definition",
					"if_statement",
					"IfExpr",
					"IfStatement",
					"import",
					"import_from_statement",
					"import_spec_list",
					"import_statement",
					"InitList",
					"interface_type",
					"jsx_element",
					"jsx_self_closing_element",
					"list",
					"list_literal",
					"literal_value",
					"method",
					"method_definition",
					"object",
					"object_pattern",
					"object_type",
					"operation_type",
					"ParamDeclList",
					"parenthesized_expression",
					"repeat_statement",
					"return",
					"return_statement",
					"selector",
					"short_var_declaration",
					"statement",
					"statement_block",
					"switch_body",
					"switch_case",
					"switch_default",
					"switch_expression",
					"switch_statement",
					"SwitchExpr",
					"table",
					"table",
					"table_constructor",
					"ternary_expression",
					"try",
					"try_statement",
					"tuple",
					"type",
					"var",
					"var_declaration",
					"while",
					"while_statement",
					"with",
					"with_statement",
				},
			},
		},
		exclude = {
			node_type = {
				["*"] = {},
			},
		},
	},
})

-- hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
-- hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_tab_indent_level)
hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
