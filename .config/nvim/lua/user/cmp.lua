local utils = require("user.utils")

local cmp = utils.safe_require("cmp")
if not cmp then
	return
end

local luasnip = utils.safe_require("luasnip")
if not luasnip then
	return
end

-- Load VSCode snippets (deferred to prevent conflicts)
vim.schedule(function()
	require("luasnip.loaders.from_vscode").lazy_load()
	luasnip.filetype_extend("blade", { "html" })
end)

-- Helper functions
local has_words_before = function()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

-- Icons configuration
local kind_icons = {
	Text = "",
	Method = "",
	Function = "",
	Constructor = "",
	Field = "",
	Variable = "",
	Class = "",
	Interface = "",
	Module = "",
	Property = "",
	Unit = "",
	Value = "",
	Enum = "",
	Keyword = "",
	Snippet = "",
	Color = "",
	File = "",
	Reference = "",
	Folder = "",
	EnumMember = "",
	Constant = "",
	Struct = "",
	Event = "",
	Operator = "",
	TypeParameter = "",
	Codeium = "",
}

-- Main setup
cmp.setup({
	enabled = function()
		-- Skip completion in special buffers unless it's a DAP buffer
		local buftype = vim.bo.buftype
		if buftype == "prompt" then
			return require("cmp_dap").is_dap_buffer()
		end
		return true
	end,

	completion = {
		autocomplete = false,
	},

	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},

	mapping = {
		["<C-k>"] = cmp.mapping.scroll_docs(-1),
		["<C-j>"] = cmp.mapping.scroll_docs(1),
		["<C-Space>"] = cmp.mapping.complete(),
		["<ESC>"] = cmp.mapping.close(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			elseif has_words_before() then
				cmp.complete()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	},

	formatting = {
		fields = { "kind", "abbr", "menu" },
		format = function(entry, vim_item)
			vim_item.kind = kind_icons[vim_item.kind]
			vim_item.menu = ({
				codeium = "[Codeium]",
				nvim_lsp = "[LSP]",
				nvim_lua = "[NvimLua]",
				luasnip = "[Snippet]",
				buffer = "[Buffer]",
				path = "[Path]",
				spell = "[Spell]",
				dap = "[Debug]",
			})[entry.source.name]
			return vim_item
		end,
	},

	sources = (function()
		local default_sources = {
			{ name = "codeium", priority = 1000 },
			{ name = "nvim_lsp", priority = 900 },
			{ name = "luasnip", priority = 750 },
			{ name = "nvim_lua", priority = 700 },
			{ name = "buffer", priority = 500 },
			{ name = "path", priority = 250 },
			{ name = "spell", priority = 200 },
		}
		return default_sources
	end)(),

	window = {
		documentation = cmp.config.window.bordered(),
		completion = cmp.config.window.bordered(),
	},

	experimental = {
		ghost_text = true,
	},
})

-- Cmdline setup
cmp.setup.cmdline({ "/", "?" }, {
	view = {
		entries = { name = "custom" },
	},
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

cmp.setup.cmdline(":", {
	view = {
		entries = { name = "custom" },
	},
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
		{ name = "cmdline" },
	}),
})

-- DAP-specific setup (only activates in debug buffers)
cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
	sources = {
		{ name = "dap" },
	},
})

-- Clean snippet session when leaving insert mode
vim.api.nvim_create_autocmd("ModeChanged", {
	pattern = "*",
	callback = function()
		if
			((vim.v.event.old_mode == "s" and vim.v.event.new_mode == "n") or vim.v.event.old_mode == "i")
			and luasnip.session.current_nodes[vim.api.nvim_get_current_buf()]
			and not luasnip.session.jump_active
		then
			luasnip.unlink_current()
		end
	end,
})
