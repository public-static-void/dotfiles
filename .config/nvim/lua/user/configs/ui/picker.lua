local utils = require("user.utils")

local picker = utils.safe_require("fzf-lua")
if not picker then
	return
end

picker.setup()

local M = {}

function M.find_files()
	picker.files()
end

function M.oldfiles()
	picker.oldfiles()
end

function M.live_grep()
	picker.live_grep()
end

function M.buffers()
	picker.buffers()
end

function M.tabs()
	picker.tabs()
end

function M.marks()
	picker.marks()
end

function M.registers()
	picker.registers()
end

picker.register_ui_select()

return M
