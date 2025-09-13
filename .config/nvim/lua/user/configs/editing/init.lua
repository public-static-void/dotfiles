-- Central editing module aggregating various editing related components.
-- Usage: require("user.editing") loads all editing-related configs.

local utils = require("user.utils")

-- Safe require to avoid config breakage if a module is missing or fails.
local autotags = utils.safe_require("user.configs.editing.autotags") or {}
local bufdelete = utils.safe_require("user.configs.editing.bufdelete") or {}
local comment = utils.safe_require("user.configs.editing.comment") or {}
local flash = utils.safe_require("user.configs.editing.flash") or {}
local hardtime = utils.safe_require("user.configs.editing.hardtime") or {}
local hightlight_colors = utils.safe_require("user.configs.editing.highlight_colors") or {}
local mini_ai = utils.safe_require("user.configs.editing.mini_ai") or {}
local mini_cursorword = utils.safe_require("user.configs.editing.mini_cursorword") or {}
local mini_pairs = utils.safe_require("user.configs.editing.mini_pairs") or {}
local mini_surround = utils.safe_require("user.configs.editing.mini_surround") or {}
local neogen = utils.safe_require("user.configs.editing.neogen") or {}
local treesitter = utils.safe_require("user.configs.editing.treesitter") or {}

return {
	autotags = autotags,
	bufdelete = bufdelete,
	comment = comment,
	flash = flash,
	hardtime = hardtime,
	hightlight_colors = hightlight_colors,
	mini_ai = mini_ai,
	mini_cursorword = mini_cursorword,
	mini_pairs = mini_pairs,
	mini_surround = mini_surround,
	neogen = neogen,
	treesitter = treesitter,
}
