local utils = require("user.utils")

local misc = utils.safe_require("mini.misc")
if not misc or not misc then
	return
end

misc.setup({})

misc.setup_termbg_sync()
misc.setup_auto_root()
misc.setup_restore_cursor()
