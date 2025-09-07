--- Central utility module re-exporting all submodules under a flat API.
--- This proxy module aggregates filesystem, module loading, project root,
--- and Java-specific utilities to provide backward-compatible access.
---
--- Benefits:
--- - Old references such as `utils.safe_require` continue to work unchanged.
--- - Internal code remains modular and organized into separate files.
--- - Avoids breaking downstream code that depends on the original `utils` table.
---
--- @module user.utils
local fs = require("user.utils.fs") or {}
local modules = require("user.utils.modules") or {}
local project = require("user.utils.project") or {}
local java = require("user.utils.lang.java") or {}
local dap_helpers = require("user.utils.dap") or {}

local M = {}

-- Import all public functions from filesystem utilities (fs.lua)
for k, v in pairs(fs) do
	M[k] = v
end

-- Import all public functions from module utilities (modules.lua)
for k, v in pairs(modules) do
	M[k] = v
end

-- Import all public functions from project utilities (project.lua)
for k, v in pairs(project) do
	M[k] = v
end

-- Import all public functions from Java-specific utilities (lang/java.lua)
for k, v in pairs(java) do
	M[k] = v
end

-- Add dap helpers functions to top-level utils table
for k, v in pairs(dap_helpers) do
	M[k] = v
end

return M
