local utils = require("user.utils")

local M = {}

-- TODO: backfill this to template
M.setup = function()
	local signs = {
		{ name = "DiagnosticSignError", text = "" },
		{ name = "DiagnosticSignWarn", text = "" },
		{ name = "DiagnosticSignHint", text = "" },
		{ name = "DiagnosticSignInfo", text = "" },
	}

	for _, sign in ipairs(signs) do
		vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
	end

	local config = {
		-- disable virtual text
		virtual_lines = false,
		virtual_text = false,
		-- show signs
		signs = {
			active = signs,
		},
		update_in_insert = false,
		underline = true,
		severity_sort = true,
		float = {
			focusable = true,
			style = "minimal",
			border = "rounded",
			source = "always",
			header = "",
			prefix = "",
		},
	}

	vim.diagnostic.config(config)

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = "rounded",
		width = 60,
	})

	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
		border = "rounded",
		width = 60,
	})
end

local function lsp_highlight_document(client)
	-- Set autocommands conditional on server_capabilities
	local illuminate = utils.safe_require("illuminate")
	if not illuminate then
		return
	end
	illuminate.on_attach(client)
end

-- Disable formatting capabilities for specific servers
local function disable_formatting(client)
	local format_disabled_servers = {
		"jsonls",
		"ts_ls",
		"lua_ls",
		"cssls",
		"html",
		"htmx",
		"marksman",
		"jdtls",
		"kotlin_language_server",
		"sqls",
	}

	for _, server in ipairs(format_disabled_servers) do
		if client.name == server then
			client.server_capabilities.documentFormattingProvider = false
			client.server_capabilities.documentRangeFormattingProvider = false
			if client.name == "jdtls" then
				require("jdtls").setup_dap({ hotcodereplace = "auto" })
				require("jdtls.dap").setup_dap_main_class_configs()
			end
			break -- Exit loop once the server is found and processed
		end
	end
end

M.on_attach = function(client)
	disable_formatting(client)
	lsp_highlight_document(client)
end

-- Create capabilities with cmp_nvim_lsp integration
local capabilities = vim.lsp.protocol.make_client_capabilities()

local cmp_nvim_lsp = utils.safe_require("cmp_nvim_lsp")
if not cmp_nvim_lsp then
	return
end

M.capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

return M
