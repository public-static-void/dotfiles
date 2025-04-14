-- lua/user/lsp_settings/lua_ls.lua

local config_path = vim.fn.stdpath("config") -- Neovim config path (~/.config/nvim)
local runtime_path = vim.api.nvim_get_runtime_file("", true) -- Neovim runtime files

return {
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT", -- Neovim uses LuaJIT
				path = vim.split(package.path, ";"), -- Include standard Lua paths
			},
			diagnostics = {
				globals = { "vim" }, -- Recognize `vim` as a global variable
			},
			workspace = {
				library = {
					runtime_path, -- Include Neovim runtime files
					config_path .. "/lua", -- Include your Neovim configuration directory
				},
				checkThirdParty = false, -- Disable third-party library scanning for speed
			},
			telemetry = {
				enable = false, -- Disable telemetry for privacy and performance
			},
		},
	},

	on_init = function(client)
		local workspace_folders = client.workspace_folders or {}
		local root_dir = workspace_folders[1] and workspace_folders[1].name or config_path

		-- Add support for resolving folders with an init.lua file
		client.config.settings.Lua.runtime.path[#client.config.settings.Lua.runtime.path + 1] = "?.lua"
		client.config.settings.Lua.runtime.path[#client.config.settings.Lua.runtime.path + 1] = "?/init.lua"

		-- Ensure the library includes runtime files and config directory
		client.config.settings.Lua.workspace.library =
			vim.tbl_extend("force", client.config.settings.Lua.workspace.library or {}, {
				runtime_path,
				config_path .. "/lua",
			})

		client.notify("workspace/didChangeConfiguration")
	end,
}
