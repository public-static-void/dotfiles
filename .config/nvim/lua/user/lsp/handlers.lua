local utils = require("user.utils")

local M = {}

-- TODO: backfill this to template
M.setup = function()
	-- Define custom icons for diagnostics
	local signs = {
		[vim.diagnostic.severity.ERROR] = { text = "", hl_group = "DiagnosticSignError" },
		[vim.diagnostic.severity.WARN] = { text = "", hl_group = "DiagnosticSignWarn" },
		[vim.diagnostic.severity.HINT] = { text = "󰛨", hl_group = "DiagnosticSignHint" },
		[vim.diagnostic.severity.INFO] = { text = "", hl_group = "DiagnosticSignInfo" },
	}

	-- Fallback colors (default VSCode colors)
	local fallback_colors = {
		DiagnosticSignError = { fg = "#f44747", bg = "NONE" }, -- Red (Error)
		DiagnosticSignWarn = { fg = "#ffcc00", bg = "NONE" }, -- Yellow (Warning)
		DiagnosticSignHint = { fg = "#10b981", bg = "NONE" }, -- Green (Hint)
		DiagnosticSignInfo = { fg = "#3794ff", bg = "NONE" }, -- Blue (Info)
	}

	-- Dynamically configure highlight groups based on the current color scheme
	local fallback_groups = {
		DiagnosticSignError = "Error",
		DiagnosticSignWarn = "Warning",
		DiagnosticSignHint = "Hint",
		DiagnosticSignInfo = "Info",
	}

	for hl_group, fallback in pairs(fallback_groups) do
		local existing_hl = vim.api.nvim_get_hl(0, { name = hl_group })
		local fallback_hl = vim.api.nvim_get_hl(0, { name = fallback })

		vim.api.nvim_set_hl(0, hl_group, {
			fg = existing_hl.fg or fallback_hl.fg or fallback_colors[hl_group].fg,
			bg = existing_hl.bg or fallback_hl.bg or fallback_colors[hl_group].bg,
			ctermfg = existing_hl.ctermfg or nil,
			ctermbg = existing_hl.ctermbg or nil,
		})
	end

	-- Use a namespace to configure diagnostic signs
	local ns_id = vim.api.nvim_create_namespace("CustomDiagnostics")

	vim.diagnostic.config({
		signs = {
			namespace_id = ns_id,
			text = {
				[vim.diagnostic.severity.ERROR] = signs[vim.diagnostic.severity.ERROR].text,
				[vim.diagnostic.severity.WARN] = signs[vim.diagnostic.severity.WARN].text,
				[vim.diagnostic.severity.HINT] = signs[vim.diagnostic.severity.HINT].text,
				[vim.diagnostic.severity.INFO] = signs[vim.diagnostic.severity.INFO].text,
			},
		},
		virtual_text = false, -- Disable virtual text
		virtual_lines = false, -- Disable virtual lines
		update_in_insert = false,
		severity_sort = true,
		float = {
			focusable = true,
			style = "minimal",
			border = "rounded",
			source = "always",
			header = "",
			prefix = "",
		},
	})

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help)
end

local function lsp_highlight_document(client)
	local illuminate = utils.safe_require("illuminate")
	if not illuminate then
		return
	end
	illuminate.on_attach(client)
end

local function disable_formatting(client)
	local format_disabled_servers = {
		"jsonls",
		"ts_ls",
		"lua_ls",
		"cssls",
		"html",
		"htmx",
		"marksman",
		"kotlin_language_server",
		"sqls",
	}

	for _, server in ipairs(format_disabled_servers) do
		if client.name == server then
			client.server_capabilities.documentFormattingProvider = false
			client.server_capabilities.documentRangeFormattingProvider = false
			break
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
if cmp_nvim_lsp then
	M.capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
else
	M.capabilities = capabilities -- Fallback to default capabilities if cmp_nvim_lsp is unavailable
end

return M
