local utils = require("user.utils")

local handlers = utils.safe_require("user.lsp.handlers")
if not handlers then
	return
end

return {
	filetypes = {
		"css",
		"scss",
		"sass",
		"html",
		"heex",
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"svelte",
		"elixir",
	},
}
