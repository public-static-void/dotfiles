local colorschemes = {
	"vscode",
	"base16-da-one-gray",
	"base16-ia-dark",
}

local fallback = "default" -- fallback to Neovim's default colorscheme

local function set_colorscheme(scheme)
	local ok, _ = pcall(function()
		vim.cmd("colorscheme " .. scheme)
	end)
	return ok
end

local success = false
for _, scheme in ipairs(colorschemes) do
	if set_colorscheme(scheme) then
		success = true
		break
	end
end

if not success then
	set_colorscheme(fallback)
	vim.notify("No listed colorscheme found, using fallback: " .. fallback, vim.log.levels.WARN)
end
