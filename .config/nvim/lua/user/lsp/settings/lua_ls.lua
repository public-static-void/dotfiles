-- https://luals.github.io/wiki/settings/
local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
	return
end

return {
	root_dir = lspconfig.util.root_pattern(".git", ".luarc.json", "init.lua"),
	settings = {
		Lua = {
			format = {
				enable = false,
			},
			diagnostics = {
				globals = { "vim", "spec" },
			},
			runtime = {
				version = "LuaJIT",
				special = {
					spec = "require",
				},
				path = {
					"lua/?.lua",
					"lua/?/init.lua",
				},
			},
			workspace = {
				checkThirdParty = false,
				library = {
					vim.fn.expand("$VIMRUNTIME/lua"),
					vim.fn.expand("$XDG_CONFIG_HOME") .. "/nvim/lua",
					"./lua",
				},
			},
			hint = {
				enable = false,
				arrayIndex = "Disable", -- "Enable" | "Auto" | "Disable"
				await = true,
				paramName = "Disable", -- "All" | "Literal" | "Disable"
				paramType = true,
				semicolon = "All", -- "All" | "SameLine" | "Disable"
				setType = false,
			},
			telemetry = {
				enable = false,
			},
		},
	},
}
