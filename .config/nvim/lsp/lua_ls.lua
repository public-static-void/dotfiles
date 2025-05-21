local handlers = require("user.lsp.handlers")
return {
	on_attach = handlers.on_attach,
	capabilities = handlers.capabilities,
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
				path = vim.split(package.path, ";"),
			},
			diagnostics = {
				-- no need for 'globals'
			},
			telemetry = {
				enable = false,
			},
		},
	},
}
