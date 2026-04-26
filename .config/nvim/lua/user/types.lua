--- Type definitions for plugin specifications
-- This file is typically located at `lua/user/types.lua`.
-- It is discovered automatically by LuaLS.

-- Main plugin specification type for vim.pack
--- Mirrors the vim.pack PluginSpec interface.
--- @class Plugin
--- @field src string Full git URL of the plugin source
--- @field name? string Optional override name
--- @field version? string Semver, git tag, or "*" to lock version
--- @field build? string|fun(self:Plugin) Build command or setup function
--- @field dependencies? string[]|Plugin[] List of dependent plugins
--- @field dev? boolean If true, plugin is in development mode (local)
--- @field dir? string Local directory path if using a local plugin

return {}
