local utils = require("user.utils")

local handlers = utils.safe_require("user.lsp.handlers")
if not handlers then
	return
end

local filetypes = { "zig" }

--- Markers to identify project root directory
local root_markers = { "zls.json", "build.zig", ".git" }

--- Determine the root directory by looking for root markers upwards
---@param bufnr number
---@param on_dir function
local function root_dir(bufnr, on_dir)
	local filepath = vim.api.nvim_buf_get_name(bufnr)
	if not filepath or filepath == "" then
		on_dir(vim.loop.cwd())
		return
	end
	local root = utils.find_root(filepath, root_markers)
	on_dir(root or vim.loop.cwd())
end

--- Adjust command dynamically based on presence of zls.json in root
---@param new_config table
---@param new_root_dir string
local function on_new_config(new_config, new_root_dir)
	local config_path = new_root_dir and (new_root_dir .. "/zls.json") or nil
	if config_path and vim.fn.filereadable(config_path) == 1 then
		new_config.cmd = { "zls", "--config-path", "zls.json" }
	else
		new_config.cmd = cmd_default
	end
end

local single_file_support = true

local cmd = { "zls" }

return {
	cmd = cmd,
	filetypes = filetypes,
	root_dir = root_dir,
	single_file_support = single_file_support,
	on_new_config = on_new_config,
	on_attach = handlers.on_attach,
	capabilities = handlers.capabilities,
}
