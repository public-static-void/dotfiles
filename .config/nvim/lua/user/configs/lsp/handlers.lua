local M = {}

-- Helper function: diagnostic sign and color template
local function diagnostic_sign_template()
	return {
		signs = {
			[vim.diagnostic.severity.ERROR] = { text = "", hl_group = "DiagnosticSignError" },
			[vim.diagnostic.severity.WARN] = { text = "", hl_group = "DiagnosticSignWarn" },
			[vim.diagnostic.severity.HINT] = { text = "󰛨", hl_group = "DiagnosticSignHint" },
			[vim.diagnostic.severity.INFO] = { text = "", hl_group = "DiagnosticSignInfo" },
		},
		fallback_colors = {
			DiagnosticSignError = { fg = "#f44747", bg = "NONE" },
			DiagnosticSignWarn = { fg = "#ffcc00", bg = "NONE" },
			DiagnosticSignHint = { fg = "#10b981", bg = "NONE" },
			DiagnosticSignInfo = { fg = "#3794ff", bg = "NONE" },
		},
		fallback_groups = {
			DiagnosticSignError = "Error",
			DiagnosticSignWarn = "Warning",
			DiagnosticSignHint = "Hint",
			DiagnosticSignInfo = "Info",
		},
	}
end

M.setup = function()
	-- Use the template for diagnostic signs and colors
	local template = diagnostic_sign_template()
	local signs = template.signs
	local fallback_colors = template.fallback_colors
	local fallback_groups = template.fallback_groups

	-- Dynamically configure highlight groups based on the current color scheme
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
		virtual_text = false,
		virtual_lines = false,
		update_in_insert = false,
		severity_sort = true,
		float = {
			focusable = true,
			style = "minimal",
			border = "rounded",
			source = true,
			header = "",
			prefix = "",
		},
	})
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()

return M
