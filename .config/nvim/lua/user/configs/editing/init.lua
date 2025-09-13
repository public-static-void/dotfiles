-- Central editing module aggregating various editing related components.
-- Usage: require("user.editing") loads all editing-related configs.

local utils = require("user.utils")

-- Safe require to avoid config breakage if a module is missing or fails.
local autotags = utils.safe_require("user.configs.editing.autotags") or {}
local comment = utils.safe_require("user.configs.editing.comment") or {}
local neogen = utils.safe_require("user.configs.editing.neogen") or {}
local treesitter = utils.safe_require("user.configs.editing.treesitter") or {}

return {
	autotags = autotags,
	comment = comment,
	neogen = neogen,
	treesitter = treesitter,
}
