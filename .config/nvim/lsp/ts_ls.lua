local utils = require("user.utils")

local handlers = utils.safe_require("user.configs.lsp.handlers")
if not handlers then
	return
end

local filetypes = {
	"javascript",
	"javascriptreact",
	"javascript.jsx",
	"typescript",
	"typescriptreact",
	"typescript.tsx",
}

--- Root markers used to identify the TypeScript project root.
--- Includes common lock files and config files.
local root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" }

--- Finds the root directory for current TypeScript buffer.
--- Uses your utils.find_root helper for consistency.
---@param bufnr number Buffer number
---@param on_dir function Callback with root directory string argument
local function root_dir(bufnr, on_dir)
	local filepath = vim.api.nvim_buf_get_name(bufnr)
	if not filepath or filepath == "" then
		on_dir(vim.loop.cwd())
		return
	end
	local root = utils.find_root(filepath, root_markers)
	on_dir(root or vim.loop.cwd())
end

local init_options = { hostInfo = "neovim" }

--- Handles the rename request for some `_typescript.rename` code actions
--- to provide better UX via showing document and triggering rename.
local function ts_rename_handler(_, result, ctx)
	local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
	vim.lsp.util.show_document({
		uri = result.textDocument.uri,
		range = {
			start = result.position,
			["end"] = result.position,
		},
	}, client.offset_encoding)
	vim.lsp.buf.rename()
	return vim.NIL
end

local handlers_custom = {
	["_typescript.rename"] = ts_rename_handler,
}

local commands = {
	["editor.action.showReferences"] = function(command, ctx)
		local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
		local file_uri, position, references = unpack(command.arguments)

		local quickfix_items = vim.lsp.util.locations_to_items(references, client.offset_encoding)
		vim.fn.setqflist({}, " ", {
			title = command.title,
			items = quickfix_items,
			context = { command = command, bufnr = ctx.bufnr },
		})

		vim.lsp.util.show_document({
			uri = file_uri,
			range = { start = position, ["end"] = position },
		}, client.offset_encoding)

		vim.cmd("botright copen")
	end,
}

---@param client table The attached LSP client
---@param bufnr number Buffer number
local function on_attach(client, bufnr)
	if handlers.on_attach then
		handlers.on_attach(client, bufnr)
	end

	vim.api.nvim_buf_create_user_command(bufnr, "LspTypescriptSourceAction", function()
		local source_actions = vim.tbl_filter(function(action)
			return vim.startswith(action, "source.")
		end, client.server_capabilities.codeActionProvider.codeActionKinds or {})
		vim.lsp.buf.code_action({ context = { only = source_actions } })
	end, { desc = "Run TypeScript source actions" })
end

local cmd = { "typescript-language-server", "--stdio" }

return {
	cmd = cmd,
	filetypes = filetypes,
	root_dir = root_dir,
	single_file_support = true,
	init_options = init_options,
	handlers = handlers_custom,
	commands = commands,
	on_attach = on_attach,
	capabilities = handlers.capabilities,
}
