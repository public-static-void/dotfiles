local utils = require("user.utils")

local handlers = utils.safe_require("user.lsp.handlers")
if not handlers then
	return
end

local filetypes = {
	"c",
	"cpp",
	"objc",
	"objcpp",
	"cuda",
}

--- Root markers used to anchor the project.
--- Priority is given to explicit compile databases, but falls back to .git.
local root_markers = {
	".clangd",
	".clang-tidy",
	".clang-format",
	"compile_commands.json",
	"compile_flags.txt",
	"configure.ac", -- AutoTools projects
	".git",
}

--- Root dir finder with utils.find_root
---@param bufnr number Buffer number
---@param on_dir function Callback with resolved root directory
local function root_dir(bufnr, on_dir)
	local filepath = vim.api.nvim_buf_get_name(bufnr)
	if not filepath or filepath == "" then
		on_dir(vim.loop.cwd())
		return
	end
	local root = utils.find_root(filepath, root_markers)
	on_dir(root or vim.loop.cwd())
end

--- Command: Switch between corresponding source and header file.
--- Invokes clangd's custom `textDocument/switchSourceHeader`.
local function switch_source_header(bufnr, client)
	local method = "textDocument/switchSourceHeader"
	if not client or not client:supports_method(method) then
		return vim.notify(("method %s not supported"):format(method), vim.log.levels.WARN)
	end
	local params = vim.lsp.util.make_text_document_params(bufnr)
	client:request(method, params, function(err, result)
		if err then
			error(tostring(err))
		end
		if not result then
			vim.notify("corresponding header/source file not found", vim.log.levels.INFO)
			return
		end
		vim.cmd.edit(vim.uri_to_fname(result))
	end, bufnr)
end

--- Command: Show symbol information at cursor.
--- Invokes clangd's custom `textDocument/symbolInfo`.
local function symbol_info(bufnr, client)
	local method = "textDocument/symbolInfo"
	if not client or not client:supports_method(method) then
		return vim.notify("Clangd: symbolInfo not supported", vim.log.levels.ERROR)
	end
	local params = vim.lsp.util.make_position_params(bufnr, client.offset_encoding)
	client:request(method, params, function(err, res)
		if err or not res or #res == 0 then
			return
		end
		local name = string.format("name: %s", res[1].name)
		local container = string.format("container: %s", res[1].containerName or "")
		vim.lsp.util.open_floating_preview({ name, container }, "plaintext", {
			height = 2,
			width = math.max(#name, #container),
			focusable = false,
			title = "Symbol Info",
		})
	end, bufnr)
end

--- Enhance default on_attach with extra clangd user commands.
---@param client lsp.Client
---@param bufnr number
local on_attach = function(client, bufnr)
	if handlers.on_attach then
		handlers.on_attach(client, bufnr)
	end

	-- Register buffer-local user commands for clangd custom methods
	vim.api.nvim_buf_create_user_command(bufnr, "LspClangdSwitchSourceHeader", function()
		switch_source_header(bufnr, client)
	end, { desc = "Switch between header and source" })

	vim.api.nvim_buf_create_user_command(bufnr, "LspClangdShowSymbolInfo", function()
		symbol_info(bufnr, client)
	end, { desc = "Show symbol info at cursor" })
end

-- Capabilities tuned for clangd
local capabilities = vim.tbl_deep_extend("force", handlers.capabilities or {}, {
	textDocument = {
		completion = {
			editsNearCursor = true, -- prioritize suggestions near cursor
		},
	},
	offsetEncoding = { "utf-8", "utf-16" }, -- let client/server negotiate
})

--- Ensure client adopts server's advertised offset encoding
---@param client lsp.Client
---@param init_result table
local on_init = function(client, init_result)
	if init_result and init_result.offsetEncoding then
		client.offset_encoding = init_result.offsetEncoding
	end
end

local cmd = { "clangd" }

return {
	cmd = cmd,
	filetypes = filetypes,
	root_markers = root_markers,
	root_dir = root_dir,
	capabilities = capabilities,
	on_init = on_init,
	on_attach = on_attach,
}
