-- Central project module aggregating various project related components.
-- Usage: require("user.project") loads all project-related configs.

local utils = require("user.utils")

-- Safe require to avoid config breakage if a module is missing or fails.
local coderunner = utils.safe_require("user.project.coderunner") or {}

return {
	coderunner = coderunner,
}
