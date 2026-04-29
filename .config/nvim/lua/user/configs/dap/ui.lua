--- UI setup for nvim-dap and associated plugins.
--- Handles dapui and virtual text plugin setup,
--- breakpoint sign highlight and automatic UI toggling.
--- @module "user.dap.ui"
local utils = require("user.utils")

local dap = utils.safe_require("dap")
if not dap then
	return
end

local dapui = utils.safe_require("dapui")
if not dapui then
	return
end

local virtual_text = utils.safe_require("nvim-dap-virtual-text")
if not virtual_text then
	return
end

dapui.setup()
virtual_text.setup({})

--- Setup highlight color and sign for breakpoints.
--- Falls back to Error hl group if available.
local function set_dap_breakpoint_color()
	local fallback_color = "#E82424"
	local ok, hl_error = pcall(vim.api.nvim_get_hl, 0, { name = "Error" })
	if ok and hl_error.fg then
		vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = string.format("#%06x", hl_error.fg) })
	else
		vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = fallback_color })
	end
	vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint" })
end

set_dap_breakpoint_color()

-- Open dap UI automatically on events.
dap.listeners.before.attach.dapui_config = function()
	dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
	dapui.open()
end

-- Close dap UI automatically on events.
dap.listeners.before.event_terminated.dapui_config = function()
	dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
	dapui.close()
end
