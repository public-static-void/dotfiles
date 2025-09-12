local utils = require("user.utils")

local alpha = utils.safe_require("alpha")
if not alpha then
	return
end

local dashboard = utils.safe_require("alpha.themes.dashboard")
if not dashboard then
	return
end

dashboard.section.header.val = {
	[[      .-.                                          ]],
	[[        ;  :          .;.       .-..-.             ]],
	[[      .;:  :  .-.  .-. `;     .'   `-' . ,';.,';.  ]],
	[[     .;' \ :.;.-' ;   ;';;  .'    ;'   ;;  ;;  ;;  ]],
	[[ .:'.;    \: `:::'`;;' ;;  ;   _.;:._.';  ;;  ';   ]],
	[[(__.'      `.          `;.'          _;        `-' ]],
}

local sep = package.config:sub(1, 1)
local config_path = vim.fn.stdpath("config") .. sep .. "init.lua"

dashboard.section.buttons.val = {
	dashboard.button("f", "  Find file", "<cmd>lua require('user.ui.picker').find_files()<CR>"),
	dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
	dashboard.button("r", "󱀸  Recently used files", "<cmd>lua require('user.ui.picker').oldfiles()<CR>"),
	dashboard.button("t", "󰮗  Find text", "<cmd>lua require('user.ui.picker').live_grep()<CR>"),
	dashboard.button("c", "  Configuration", ":e " .. config_path .. " <CR>"),
	dashboard.button("u", "󰚰  Update Plugins", "<cmd>Lazy sync<CR>"),
	dashboard.button("q", "󰩈  Quit Neovim", ":qa<CR>"),
}

local function footer()
	return "☆ ★ ☆ ★ ☆ ★ ☆ ★ ☆ ★ ☆ ★ ☆ ★ ☆ ★ ☆ ★ ☆ ★ ☆ ★ ☆ ★ ☆ "
end

dashboard.section.footer.val = footer()

dashboard.section.footer.opts.hl = "Type"
dashboard.section.header.opts.hl = "Include"
dashboard.section.buttons.opts.hl = "Keyword"

dashboard.opts.opts.noautocmd = true
-- vim.cmd([[autocmd User AlphaReady echo 'ready']])
alpha.setup(dashboard.opts)
