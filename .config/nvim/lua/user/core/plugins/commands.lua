--- vim.pack user commands module.
--- Provides :VimPackUpdate, :VimPackStatus, :VimPackSync, :VimPackDelete.

local utils = require("user.utils")

local pack_utils = utils.safe_require("user.utils.pack")
if not pack_utils then
	return
end

local plugin_names = nil

--- Set the plugin name list to use when pruning inactive plugins.
--- @param names string[]
local function set_plugin_names(names)
	plugin_names = names
end

--- vim.pack user commands for update/delete.
--- @param opts table Lua command arguments.
local function vim_pack_update(opts)
	vim.pack.update(opts.fargs[1] and vim.split(opts.fargs[1], ",") or nil, opts.bang and { force = true } or {})

	if plugin_names then
		vim.schedule(function()
			pack_utils.prune_inactive(plugin_names)
		end)
	end
end

vim.api.nvim_create_user_command("VimPackUpdate", vim_pack_update, {
	nargs = "*",
	bang = true,
	desc = "Update plugins (BANG=force) and prune unused inactive ones",
})

--- Update all plugins interactively.
vim.api.nvim_create_user_command("VimPackUpdate", vim_pack_update, {
	nargs = "*",
	bang = true,
	desc = "Update plugins (BANG=force)",
})

--- Offline plugin status view.
vim.api.nvim_create_user_command("VimPackStatus", function()
	vim.pack.update(nil, { offline = true })
end, { desc = "Show plugin status (offline)" })

--- Sync to lockfile state.
vim.api.nvim_create_user_command("VimPackSync", function()
	vim.pack.update(nil, { target = "lockfile" })
end, { desc = "Sync to lockfile" })

--- Delete plugins from disk and lockfile.
--- @param opts table Lua command arguments.
local function vim_pack_delete(opts)
	vim.pack.del(vim.split(opts.fargs[1], ","))
end

vim.api.nvim_create_user_command("VimPackDelete", vim_pack_delete, {
	nargs = "+",
	complete = function()
		local list_fn = vim.pack.list
		if type(list_fn) ~= "function" then
			return {}
		end
		return vim.fn.keys(list_fn())
	end,
	desc = "Delete plugins",
})

return {
	set_plugin_names = set_plugin_names,
}
