local utils = require("user.utils")

local handlers = utils.safe_require("user.lsp.handlers")
if not handlers then
	return
end

--- Supported filetypes for Go.
local filetypes = {
	"go",
	"gomod",
	"gowork",
	"gotemplate",
}

--- Root markers that indicate Go project root directories.
local root_markers = { "go.mod", "go.work", ".git" }

-- Cache for Go standard library path and module cache paths.
local mod_cache = nil
local std_lib = nil

--- Helper to run `go env` commands asynchronously to find Go directories.
---@param envvar_id string The environment variable key (e.g., GOROOT, GOMODCACHE)
---@param custom_subdir string? Optional subdirectory to append
---@param on_complete function Callback with detected directory or nil
local function identify_go_dir(envvar_id, custom_subdir, on_complete)
	local cmd = { "go", "env", envvar_id }
	vim.system(cmd, { text = true }, function(output)
		local res = vim.trim(output.stdout or "")
		if output.code == 0 and res ~= "" then
			if custom_subdir and custom_subdir ~= "" then
				res = res .. custom_subdir
			end
			on_complete(res)
		else
			vim.schedule(function()
				vim.notify(
					string.format(
						"[gopls] identify %s dir cmd failed with code %d: %s\n%s",
						envvar_id,
						output.code,
						table.concat(cmd, " "),
						output.stderr
					),
					vim.log.levels.WARN
				)
			end)
			on_complete(nil)
		end
	end)
end

--- Fetches and caches Go standard library source path.
---@param on_complete function Callback with path or nil
local function get_std_lib_dir(on_complete)
	if std_lib and std_lib ~= "" then
		on_complete(std_lib)
		return
	end
	identify_go_dir("GOROOT", "/src", function(dir)
		std_lib = dir
		on_complete(dir)
	end)
end

--- Fetches and caches Go module cache path.
---@param on_complete function Callback with path or nil
local function get_mod_cache_dir(on_complete)
	if mod_cache and mod_cache ~= "" then
		on_complete(mod_cache)
		return
	end
	identify_go_dir("GOMODCACHE", nil, function(dir)
		mod_cache = dir
		on_complete(dir)
	end)
end

--- Determines the project root directory based on filename.
--- Honors Go environment paths for caching and standard library.
---@param fname string File path
---@param on_dir function Callback to set root directory
local function root_dir(bufnr, on_dir)
	local fname = vim.api.nvim_buf_get_name(bufnr)
	if not fname or fname == "" then
		on_dir(vim.loop.cwd())
		return
	end

	-- Async helpers to get env paths then determine root based on those and project roots
	get_mod_cache_dir(function(mod_cache_dir)
		get_std_lib_dir(function(std_lib_dir)
			-- Check if file is inside mod_cache or std_lib and return existing client root if so
			if mod_cache_dir and fname:sub(1, #mod_cache_dir) == mod_cache_dir then
				local clients = vim.lsp.get_clients({ name = "gopls" })
				if #clients > 0 then
					on_dir(clients[#clients].config.root_dir)
					return
				end
			end

			if std_lib_dir and fname:sub(1, #std_lib_dir) == std_lib_dir then
				local clients = vim.lsp.get_clients({ name = "gopls" })
				if #clients > 0 then
					on_dir(clients[#clients].config.root_dir)
					return
				end
			end

			-- Otherwise locate root by common Go root markers
			local root = utils.find_root(fname, root_markers)
			on_dir(root or vim.loop.cwd())
		end)
	end)
end

--- Command to start `gopls`.
local cmd = { "gopls" }

return {
	cmd = cmd,
	filetypes = filetypes,
	root_dir = root_dir,
	root_markers = root_markers,
	on_attach = handlers.on_attach,
	capabilities = handlers.capabilities,
}
