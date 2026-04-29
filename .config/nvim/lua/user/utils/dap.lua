--- Helper functions for DAP configurations like building executables,
--- resolving Mason adapter paths, and async helpers.
--- @module "user.utils.dap"
local M = {}

local sep = package.config:sub(1, 1)

--- Detect if the OS is Windows.
--- @type boolean
M.is_windows = vim.uv.os_uname().sysname == "Windows_NT"

--- Constructs the full path to a Mason-installed adapter executable.
--- Works cross-platform using path separator.
--- @param pkg string Mason package name.
--- @param subpath string Relative path inside package folder.
--- @return string|nil Adapter absolute path or nil if doesn't exist.
function M.mason_adapter_path(pkg, subpath)
	local root = vim.env.MASON or (vim.fn.stdpath("data") .. sep .. "mason")
	local path = root .. sep .. "packages" .. sep .. pkg .. sep .. subpath
	if vim.uv.fs_stat(path) then
		return path
	end
	return nil
end

--- Utility to print the output of build commands to Neovim's command line.
--- @param result string Build output from shell command.
function M.print_build_output(result)
	vim.cmd("echo ''")
	for _, line in ipairs(vim.split(result, "\n", { trimempty = true })) do
		vim.cmd(string.format("echo '%s'", vim.fn.escape(line, "'")))
	end
end

--- Run a build command and find compiled executable asynchronously.
--- @param build_command string Shell build command.
--- @param find_command string Command that finds executable(s).
--- @param callback fun(executable: string) Callback fired with executable path.
function M.build_and_find_executable(build_command, find_command, callback)
	local handle = io.popen(build_command .. " 2>&1")
	if not handle then
		vim.notify("Failed to execute: " .. build_command, vim.log.levels.ERROR)
		return
	end
	local result = handle:read("*a")
	handle:close()
	M.print_build_output(result)

	local find_handle = io.popen(find_command)
	if not find_handle then
		vim.notify("Failed to execute: " .. find_command, vim.log.levels.ERROR)
		return
	end

	local find_result = find_handle:read("*a")
	find_handle:close()

	local executables = vim.split(find_result, "\n", { trimempty = true })
	if #executables == 0 then
		vim.notify("No executable found. Compilation might have failed.", vim.log.levels.ERROR)
	elseif #executables == 1 then
		callback(executables[1])
	else
		local choices = { "Select an executable:" }
		for i, executable in ipairs(executables) do
			table.insert(choices, string.format("%d: %s", i, executable))
		end
		local choice = vim.fn.inputlist(choices)
		if choice > 0 and executables[choice] then
			callback(executables[choice])
		else
			vim.notify("No valid executable selected.", vim.log.levels.ERROR)
		end
	end
end

--- Wraps build_and_find_executable in a coroutine for async dap config usage.
--- @param build_cmd fun(): string Function returning build shell command.
--- @param find_cmd fun(): string Function returning find shell command.
--- @return fun(): coroutine coroutine function yielding executable path string.
function M.async_program_builder(build_cmd, find_cmd)
	return function()
		return coroutine.create(function(co)
			M.build_and_find_executable(build_cmd(), find_cmd(), function(exe)
				coroutine.resume(co, exe)
			end)
			return coroutine.yield()
		end)
	end
end

return M
