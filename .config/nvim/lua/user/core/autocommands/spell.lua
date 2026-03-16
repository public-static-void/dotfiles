--- Spellfile Autocommands

local group = vim.api.nvim_create_augroup("GeneralSettings", { clear = false })
local languages = { { code = "de", file = "de.utf-8" }, { code = "en", file = "en.utf-8" } }
local spell_dir = vim.fn.stdpath("data") .. "/spell"

-- Ensure spell directory exists
vim.fn.mkdir(spell_dir, "p")

--- Download spellfile using system tools
local function download_spellfile(lang)
	local spl_file = spell_dir .. "/" .. lang.file .. ".spl"
	if vim.fn.filereadable(spl_file) == 0 then
		local url = "https://ftp.nluug.nl/pub/vim/runtime/spell/" .. lang.file .. ".spl"

		-- Try curl
		local cmd = string.format('curl -s -L -o "%s" "%s"', spl_file:gsub("\\", "/"), url)
		if vim.fn.system(cmd) == 0 and vim.fn.filereadable(spl_file) == 1 then
			vim.notify("Downloaded " .. lang.file .. ".spl", vim.log.levels.INFO)
			return
		end

		-- Fallback: wget
		cmd = string.format('wget -q -O "%s" "%s"', spl_file:gsub("\\", "/"), url)
		if vim.fn.system(cmd) == 0 and vim.fn.filereadable(spl_file) == 1 then
			vim.notify("Downloaded " .. lang.file .. ".spl (wget)", vim.log.levels.INFO)
			return
		end

		-- Fallback: PowerShell (Windows native)
		cmd = string.format('powershell -Command "Invoke-WebRequest \\"%s\\" -OutFile \\"%s\\""', url, spl_file)
		if vim.fn.system(cmd) == 0 and vim.fn.filereadable(spl_file) == 1 then
			vim.notify("Downloaded " .. lang.file .. ".spl (PowerShell)", vim.log.levels.INFO)
			return
		end

		vim.notify("Failed to download " .. lang.file .. ".spl - check internet/tools", vim.log.levels.WARN)
	end
end

--- Main autocmd: download base files + manage .add files
vim.api.nvim_create_autocmd("FocusGained", {
	group = group,
	pattern = "*",
	callback = function()
		for _, lang in ipairs(languages) do
			-- Download base spellfile if missing
			download_spellfile(lang)

			local add_file = spell_dir .. "/" .. lang.code .. ".utf-8.add"
			local add_spl_file = add_file .. ".spl"
			if vim.fn.filereadable(add_file) == 1 then
				local add_mtime = vim.fn.getftime(add_file)
				local spl_mtime = vim.fn.getftime(add_spl_file)
				if add_mtime > spl_mtime or spl_mtime == -1 then
					vim.cmd("silent! mkspell! " .. add_spl_file .. " " .. add_file)
				end
			end
		end
	end,
})

-- Run once on startup (one-time download)
vim.schedule(function()
	for _, lang in ipairs(languages) do
		download_spellfile(lang)
	end
end)
