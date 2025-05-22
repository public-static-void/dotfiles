local function set_colorscheme(scheme)
	local status_ok, _ = pcall(function()
		vim.cmd("colorscheme " .. scheme)
	end)
	if not status_ok then
		vim.notify("Colorscheme '" .. scheme .. "' not found!", vim.log.levels.ERROR)
		return false
	end
	return true
end

-- List of available colorschemes
local colorschemes = {
	"vscode",
	"darkplus",
	"codedark",
	"angr",
	"spacedark",
	"base16-da-one-gray",
	"base16-ia-dark",
	"pywal",
}

-- Try setting the desired colorscheme
local desired_colorscheme = colorschemes[1] -- Change index to select different schemes

if not set_colorscheme(desired_colorscheme) then
	-- Optionally try a fallback scheme if the desired one fails
	for _, scheme in ipairs(colorschemes) do
		if set_colorscheme(scheme) then
			break -- Exit loop if a valid scheme is found
		end
	end
end
