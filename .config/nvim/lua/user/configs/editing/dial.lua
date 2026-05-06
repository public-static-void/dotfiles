--- dial.nvim configuration with filetype-aware augends.
--- Provides increment/decrement for numbers, dates, booleans, colors, semver.
--- Supports custom groups for JS/TS/Python with let/const toggles.
---
--- @module "user.configs.editing.dial"
local utils = require("user.utils")

local augend = utils.safe_require("dial.augend")
local dial_config = utils.safe_require("dial.config")
if not augend or not dial_config then
	return
end

dial_config.augends:register_group({
	default = {
		augend.integer.alias.decimal,
		augend.integer.alias.hex,
		augend.date.alias["%Y-%m-%d"],
		augend.date.alias["%Y/%m/%d"],
		augend.date.alias["%m/%d"],
		augend.constant.alias.bool,
		augend.constant.alias.alpha,
		augend.constant.alias.Alpha,
	},

	visual = {
		augend.integer.alias.decimal,
		augend.hexcolor.new(),
		augend.constant.alias.bool,
		augend.constant.alias.alpha,
		augend.constant.alias.Alpha,
		augend.constant.new({
			elements = { "&&", "||" },
			word = false,
			cyclic = true,
		}),
	},

	javascript = {
		augend.integer.alias.decimal,
		augend.semver.alias.semver,
		augend.constant.new({
			elements = { "let", "const" },
			cyclic = true,
		}),
	},

	python = {
		augend.integer.alias.decimal,
		augend.constant.new({
			elements = { "True", "False" },
			cyclic = true,
		}),
	},
})

--- Filetype-specific augend overrides.
dial_config.augends:on_filetype({
	javascript = { augend.constant.alias.javascript },
	typescript = { augend.constant.alias.typescript },
	python = { augend.constant.alias.python },
})

return {}
