local status_ok, indent_blankline = pcall(require, "ibl")
if not status_ok then
	return
end

local hooks_status_ok, hooks = pcall(require, "ibl.hooks")
if not hooks_status_ok then
	return
end

indent_blankline.setup({
	enabled = true,
	exclude = {
		buftypes = {
			"terminal",
			"nofile",
		},
		filetypes = {
			"help",
			"startify",
			"dashboard",
			"packer",
			"neogitstatus",
			"NvimTree",
			"Trouble",
		},
	},
	indent = {
		char = "▏",
		tab_char = "▏",
	},
	whitespace = {
		highlight = { "Function", "Label" },
		remove_blankline_trail = true,
	},
	scope = {
		enabled = true,
		char = "▍",
		show_start = false,
		show_end = false,
		include = {
			node_type = {
				["*"] = {
					"class",
					"return",
					"function",
					"method",
					"^if",
					"^while",
					"jsx_element",
					"^for",
					"^object",
					"^table",
					"block",
					"arguments",
					"if_statement",
					"else_clause",
					"jsx_element",
					"jsx_self_closing_element",
					"try_statement",
					"catch_clause",
					"import_statement",
					"operation_type",
					"argument_list",
					"arguments",
					"assignment_statement",
					"Block",
					"chunk",
					"class",
					"ContainerDecl",
					"dictionary",
					"do_block",
					"do_statement",
					"element",
					"except",
					"FnCallArguments",
					"for",
					"for_statement",
					"function",
					"function_declaration",
					"function_definition",
					"if_statement",
					"IfExpr",
					"IfStatement",
					"import",
					"InitList",
					"list_literal",
					"method",
					"object",
					"ParamDeclList",
					"repeat_statement",
					"selector",
					"SwitchExpr",
					"table",
					"table_constructor",
					"try",
					"tuple",
					"type",
					"var",
					"while",
					"while_statement",
					"with",
				},
			},
		},
	},
})

-- hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
-- hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_tab_indent_level)
