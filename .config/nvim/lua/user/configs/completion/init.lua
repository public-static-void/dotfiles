-- Central Completion module aggregating various Completion related components.
-- Usage: require("user.completion") loads all editing-related configs.

local utils = require("user.utils")

-- Safe require to avoid config breakage if a module is missing or fails.
local blink = utils.safe_require("user.configs.completion.blink") or {}
local codeium = utils.safe_require("user.configs.completion.codeium") or {}
local minuet = utils.safe_require("user.configs.completion.minuet") or {}

return {
	blink = blink,
	codeium = codeium,
	minuet = minuet,
}
