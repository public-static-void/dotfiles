--- Central Autocommands module aggregating all submodules.
--- Usage: require("autocommands") safely loads all autocmd groups.
local utils = require("user.utils")

-- Safe require each autocmd submodule so errors won't break startup
local general = utils.safe_require("user.core.autocommands.general") or {}
local folding = utils.safe_require("user.core.autocommands.folding") or {}
local spell = utils.safe_require("user.core.autocommands.spell") or {}
local filetypes = utils.safe_require("user.core.autocommands.filetypes") or {}

return {
	general = general,
	folding = folding,
	spell = spell,
	filetypes = filetypes,
}
