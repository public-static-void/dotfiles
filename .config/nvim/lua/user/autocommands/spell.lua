--- Spellfile Autocommands
-- Automatically regenerates Vim spellfiles if the .add file
-- was modified since the last compiled version.

local group = vim.api.nvim_create_augroup("GeneralSettings", { clear = false })

-- List of languages to manage spellfiles for
local languages = { "de", "en" }

--- On regaining focus, rebuild spell file if newer dictionary exists
vim.api.nvim_create_autocmd("FocusGained", {
	group = group,
	pattern = "*",
	callback = function()
		local spell_dir = vim.fn.stdpath("data") .. "/spell"
		for _, lang in ipairs(languages) do
			local add_file = spell_dir .. "/" .. lang .. ".utf-8.add"
			local spl_file = add_file .. ".spl"
			if vim.fn.filereadable(add_file) == 1 then
				local add_mtime = vim.fn.getftime(add_file)
				local spl_mtime = vim.fn.getftime(spl_file)
				if add_mtime > spl_mtime or spl_mtime == -1 then
					vim.cmd("silent! mkspell! " .. spl_file .. " " .. add_file)
				end
			end
		end
	end,
})
