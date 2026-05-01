--- vim.pack user commands module.
--- Provides :VimPackUpdate, :VimPackStatus, :VimPackSync, :VimPackDelete.

--- vim.pack user commands for update/delete.
--- @param opts table Lua command arguments.
local function vim_pack_update(opts)
	vim.pack.update(opts.fargs[1] and vim.split(opts.fargs[1], ",") or nil, opts.bang and { force = true } or {})
end

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
