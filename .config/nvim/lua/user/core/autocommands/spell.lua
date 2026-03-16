--- Spellfile Autocommands
-- Automatically downloads base spellfiles + regenerates .add files

local group = vim.api.nvim_create_augroup("GeneralSettings", { clear = false })
local languages = { "de", "en" }
local spell_dir = vim.fn.stdpath("data") .. "/spell"

-- Ensure spell directory exists
vim.fn.mkdir(spell_dir, "p")

--- Trigger Neovim's built-in spellfile download mechanism
local function ensure_base_spellfile(lang)
	local spl_file = spell_dir .. "/" .. lang .. ".utf-8.spl"
	if vim.fn.filereadable(spl_file) == 0 then
		-- Temporarily enable spell to trigger automatic download
		vim.cmd("silent! set spell spelllang=" .. lang .. "_utf-8")
		vim.cmd("silent! set nospell") -- Immediately disable to avoid side effects
	end
end

--- On regaining focus, ensure base files + rebuild spell file if newer dictionary exists
vim.api.nvim_create_autocmd("FocusGained", {
	group = group,
	pattern = "*",
	callback = function()
		for _, lang in ipairs(languages) do
			-- Ensure base spellfile exists (auto-downloads if missing)
			ensure_base_spellfile(lang)

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

-- Initial run on startup (fully automatic)
vim.schedule(function()
	for _, lang in ipairs(languages) do
		ensure_base_spellfile(lang)
	end
end)
