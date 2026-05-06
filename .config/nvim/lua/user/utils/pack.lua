local M = {}

--- Prune inactive plugins that are not in the current spec list.
--- Called only after an update, not on startup.
--- @param spec_names string[] plugin names from vim.pack.add(...) list
function M.prune_inactive(spec_names)
	-- Build a set of plugins we still want.
	local wanted = {}
	for _, name in ipairs(spec_names) do
		wanted[name] = true
	end

	-- Collect names of plugins that are:
	--  - managed by vim.pack
	--  - not active
	--  - not in the current spec list
	local to_delete = {}
	for _, plugin in ipairs(vim.pack.get()) do
		local name = plugin.spec.name
		if not plugin.active and not wanted[name] then
			table.insert(to_delete, name)
		end
	end

	if #to_delete == 0 then
		vim.notify("No unused inactive plugins to prune", vim.log.levels.INFO)
		return
	end

	vim.pack.del(to_delete)
	vim.notify(
		("Pruned %d inactive plugins: %s"):format(#to_delete, table.concat(to_delete, ", ")),
		vim.log.levels.INFO
	)
end

return M
