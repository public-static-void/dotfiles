-- Central project module aggregating various project related components.
-- Usage: require("user.project") loads all project-related configs.

local utils = require("user.utils")

-- Safe require to avoid config breakage if a module is missing or fails.
local coderunner = utils.safe_require("user.configs.project.coderunner") or {}
local mini_misc = utils.safe_require("user.configs.project.mini_misc") or {}
local mkdir = utils.safe_require("user.configs.project.mkdir") or {}
local rainbow_csv = utils.safe_require("user.configs.project.rainbow_csv") or {}
local vim_blade = utils.safe_require("user.configs.project.vim_blade") or {}

return {
	coderunner = coderunner,
	mini_misc = mini_misc,
	mkdir = mkdir,
	rainbow_csv = rainbow_csv,
	vim_blade = vim_blade,
}
