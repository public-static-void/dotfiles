local utils = require("user.utils")

local handlers = utils.safe_require("user.lsp.handlers")
if not handlers then
	return
end

local root_markers = { "package.json", ".git" }

local function get_root_dir(fname)
	return vim.fs.root(fname, root_markers)
end

return {
	cmd = { "vls" },
	filetypes = { "vue" },
	root_dir = get_root_dir,
	settings = {},
}
