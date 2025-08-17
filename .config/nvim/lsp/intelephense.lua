local utils = require("user.utils")

local handlers = utils.safe_require("user.lsp.handlers")
if not handlers then
	return
end

return {
	on_attach = handlers.on_attach,
	capabilities = handlers.capabilities,
	cmd = { "intelephense", "--stdio" },
	filetypes = { "php" },
	root_markers = { "composer.json", ".git" },
	settings = {
		intelephense = {
			diagnostics = {
				undefinedTypes = false,
				undefinedFunctions = false,
				undefinedConstants = false,
				undefinedClassConstants = false,
				undefinedMethods = false,
				undefinedProperties = false,
				undefinedVariables = true,
			},
		},
	},
	on_init = function(client)
		client.server_capabilities.documentFormattingProvider = false
	end,
}
