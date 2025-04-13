-- lua/user/lsp/settings/lua_ls.lua
local lspconfig = require('lspconfig')

-- 1. Force Neovim config as the ONLY workspace
local config_path = vim.fn.stdpath('config')
local runtime_path = vim.env.VIMRUNTIME

-- 2. Completely disable workspace scanning
local function get_root_dir()
  return config_path -- Always force config directory
end

-- 3. Minimal required settings
lspconfig.lua_ls.setup({
  root_dir = get_root_dir,
  single_file_support = false, -- CRITICAL for config files

  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
        path = {
          config_path..'/lua/?.lua',
          config_path..'/lua/?/init.lua',
          runtime_path..'/lua/?.lua',
          runtime_path..'/lua/?/init.lua',
        }
      },
      workspace = {
        library = {
          runtime_path..'/lua', -- Neovim runtime
          config_path..'/lua'   -- Your config
        },
        -- Prevent all automatic scanning
        checkThirdParty = false,
        ignoreSubmodules = true,
        ignoreDir = { '/', '~', vim.env.HOME, '*' }, -- Block everything else
        maxPreload = 30000,
        preloadFileSize = 500
      },
      diagnostics = {
        disable = { 'missing-fields' }, -- Reduce noise
        globals = { 'vim' }
      },
      telemetry = { enable = false }
    }
  }
})
