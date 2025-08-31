local utils = require("user.utils")

local dap = utils.safe_require("dap")
if not dap then
	return
end

-- DAP UI and virtual text

local dapui = utils.safe_require("dapui")
if not dapui then
	return
end

dapui.setup()

local virtual_text = utils.safe_require("nvim-dap-virtual-text")
if not virtual_text then
	return
end

virtual_text.setup({})

-- Helper for Mason adapter path
local sep = package.config:sub(1, 1)
local is_windows = vim.uv.os_uname().sysname == "Windows_NT"
local function mason_adapter_path(pkg, subpath)
	-- Compose the full path to an adapter, cross-platform
	local root = vim.env.MASON or (vim.fn.stdpath("data") .. sep .. "mason")
	local path = root .. sep .. "packages" .. sep .. pkg .. sep .. subpath
	if vim.uv.fs_stat(path) then
		return path
	else
		return nil
	end
end

-- Build helpers
local function print_build_output(result)
	vim.cmd("echo ''")
	for _, line in ipairs(vim.split(result, "\n", { trimempty = true })) do
		vim.cmd(string.format("echo '%s'", vim.fn.escape(line, "'")))
	end
end

local function build_and_find_executable(build_command, find_command, callback)
	local handle = io.popen(build_command .. " 2>&1")
	if not handle then
		vim.notify("Failed to execute: " .. build_command, vim.log.levels.ERROR)
		return
	end
	local result = handle:read("*a")
	handle:close()
	print_build_output(result)

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

local function async_program_builder(build_cmd, find_cmd)
	return function()
		return coroutine.create(function(co)
			build_and_find_executable(build_cmd(), find_cmd(), function(exe)
				coroutine.resume(co, exe)
			end)
			local exe = coroutine.yield()
			return exe
		end)
	end
end

-- Java
dap.configurations.java = {
	{
		type = "java",
		request = "launch",
		name = "Launch Java Main Class",
		cwd = vim.fn.getcwd(),
		console = "internalConsole",
	},
}

-- C & Rust (codelldb, gcc)
dap.adapters.codelldb = {
	type = "server",
	host = "127.0.0.1",
	port = "${port}",
	executable = {
		command = mason_adapter_path("codelldb", "extension" .. sep .. "adapter" .. sep .. "codelldb"),
		args = { "--port", "${port}" },
	},
}

-- C++ (codelldb, g++)
dap.configurations.cpp = {
	{
		name = "Launch file",
		type = "codelldb",
		request = "launch",
		program = async_program_builder(function()
			local current_file = vim.fn.expand("%:p")
			local output_binary = "." .. sep .. "build" .. sep .. vim.fn.fnamemodify(current_file, ":t:r")
			if is_windows then
				return string.format(
					"if not exist build mkdir build && g++ %s -g -o %s.exe",
					current_file,
					output_binary
				)
			else
				return string.format("mkdir -p build && g++ %s -g -o %s", current_file, output_binary)
			end
		end, function()
			local current_file = vim.fn.expand("%:p")
			local output_binary = vim.fn.fnamemodify(current_file, ":t:r")
			if is_windows then
				return string.format("dir /b build\\%s.exe", output_binary)
			else
				return string.format("find .%sbuild -maxdepth 1 -type f -name '%s'", sep, output_binary)
			end
		end),
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
	},
}
dap.configurations["c++"] = dap.configurations.cpp
dap.configurations["c"] = dap.configurations.cpp

-- Rust (codelldb)
dap.configurations.rust = {
	{
		name = "Launch file",
		type = "codelldb",
		request = "launch",
		program = async_program_builder(function()
			return "cargo build"
		end, function()
			if is_windows then
				return "dir /b ..\\target\\debug\\*.exe"
			else
				return string.format("find ..%starget%sdebug -maxdepth 1 -type f -executable", sep, sep)
			end
		end),
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
	},
}

-- Python (debugpy)
dap.adapters.python = {
	type = "executable",
	command = (function()
		if is_windows then
			return mason_adapter_path("debugpy", "venv" .. sep .. "Scripts" .. sep .. "python.exe")
		else
			return mason_adapter_path("debugpy", "venv" .. sep .. "bin" .. sep .. "python")
		end
	end)(),
	args = { "-m", "debugpy.adapter" },
}
dap.configurations.python = {
	{
		name = "Launch file",
		type = "python",
		request = "launch",
		program = "${file}",
		cwd = vim.fn.getcwd(),
		console = "integratedTerminal",
		pythonPath = function()
			local cwd = vim.fn.getcwd()
			if is_windows then
				if vim.fn.executable(cwd .. sep .. "venv" .. sep .. "Scripts" .. sep .. "python.exe") == 1 then
					return cwd .. sep .. "venv" .. sep .. "Scripts" .. sep .. "python.exe"
				elseif vim.fn.executable(cwd .. sep .. ".venv" .. sep .. "Scripts" .. sep .. "python.exe") == 1 then
					return cwd .. sep .. ".venv" .. sep .. "Scripts" .. sep .. "python.exe"
				end
			else
				if vim.fn.executable(cwd .. sep .. "venv" .. sep .. "bin" .. sep .. "python") == 1 then
					return cwd .. sep .. "venv" .. sep .. "bin" .. sep .. "python"
				elseif vim.fn.executable(cwd .. sep .. ".venv" .. sep .. "bin" .. sep .. "python") == 1 then
					return cwd .. sep .. ".venv" .. sep .. "bin" .. sep .. "python"
				end
			end
			if is_windows then
				return mason_adapter_path("debugpy", "venv" .. sep .. "Scripts" .. sep .. "python.exe")
			else
				return mason_adapter_path("debugpy", "venv" .. sep .. "bin" .. sep .. "python")
			end
		end,
	},
}

-- Go (delve)
dap.adapters.go = {
	type = "server",
	port = "${port}",
	executable = {
		command = mason_adapter_path("delve", "dlv"),
		args = { "dap", "-l", "127.0.0.1:${port}" },
	},
}
dap.configurations.go = {
	{
		name = "Debug main.go",
		type = "go",
		request = "launch",
		program = "${file}",
	},
}

-- PHP (php-debug-adapter)
-- NOTE: Requires PHP and Xdebug to be installed and configured
-- Install PHP (i.e. `pacman -S php`)
-- Install xdebug (i.e. `pacman -S xdebug`)
-- Adjust php.ini (i.e. /etc/php/php.ini) or xdebug.ini (i.e. /etc/php/conf.d/xdebug.ini)):
-- zend_extension=xdebug.so
-- xdebug.mode=debug
-- xdebug.start_with_request=yes
-- xdebug.client_host=127.0.0.1
-- xdebug.client_port=9003
-- xdebug.remote_host=127.0.0.1
-- xdebug.remote_port=9003
-- xdebug.remote_enable=1
-- xdebug.remote_autostart=1
dap.adapters.php = {
	type = "executable",
	command = "node",
	args = { mason_adapter_path("php-debug-adapter", "extension" .. sep .. "out" .. sep .. "phpDebug.js") },
}
dap.configurations.php = {
	{
		name = "run script",
		type = "php",
		request = "launch",
		port = 9003,
		cwd = "${fileDirname}",
		program = "${file}",
		runtimeExecutable = "php",
	},
}

-- JS/TS (js-debug-adapter)
dap.adapters["pwa-node"] = {
	type = "server",
	host = "localhost",
	port = "${port}",
	executable = {
		command = "node",
		args = {
			mason_adapter_path("js-debug-adapter", "js-debug" .. sep .. "src" .. sep .. "dapDebugServer.js"),
			"${port}",
		},
	},
}
local js_based_languages = { "typescript", "javascript" }
for _, language in ipairs(js_based_languages) do
	dap.configurations[language] = {
		{
			type = "pwa-node",
			request = "launch",
			name = "Launch file",
			program = "${file}",
			runtimeExecutable = "tsx",
			cwd = "${workspaceFolder}",
			sourceMaps = true,
			resolveSourceMapLocations = { "${workspaceFolder}/**", "!**/node_modules/**" },
			console = "integratedTerminal",
			internalConsoleOptions = "neverOpen",
			skipFiles = { "<node_internals>/**", "${workspaceFolder}/node_modules/**" },
		},
	}
end

-- Lua (local-lua-debugger-vscode)
dap.adapters["local-lua"] = {
	type = "executable",
	command = "node",
	args = {
		mason_adapter_path("local-lua-debugger-vscode", "extension" .. sep .. "extension" .. sep .. "debugAdapter.js"),
	},
	enrich_config = function(config, on_config)
		config.extensionPath = mason_adapter_path("local-lua-debugger-vscode", "extension")
		on_config(config)
	end,
}
dap.configurations.lua = {
	{
		type = "local-lua",
		request = "launch",
		name = "Launch current file",
		program = {
			lua = "luajit",
			file = "${file}",
		},
		cwd = "${workspaceFolder}",
		runtimeExecutable = "luajit",
		args = {},
	},
}

-- Custom breakpoint color and sign
local function set_dap_breakpoint_color()
	local fallback_color = "#E82424"
	local ok, hl_error = pcall(vim.api.nvim_get_hl, 0, { name = "Error" })
	if ok and hl_error.fg then
		vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = string.format("#%06x", hl_error.fg) })
	else
		vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = fallback_color })
	end
	vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint" })
end
set_dap_breakpoint_color()

-- DAP UI open/close logic
dap.listeners.before.attach.dapui_config = function()
	dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
	dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
	dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
	dapui.close()
end

-- DapContinueChecked command
local adapter_exec_map = {
	codelldb = { pkg = "codelldb", exec = "extension" .. sep .. "adapter" .. sep .. "codelldb" },
	python = {
		pkg = "debugpy",
		exec = (
			is_windows and "venv" .. sep .. "Scripts" .. sep .. "python.exe"
			or "venv" .. sep .. "bin" .. sep .. "python"
		),
	},
	delve = { pkg = "delve", exec = "dlv" },
	php = { pkg = "php-debug-adapter", exec = "extension" .. sep .. "out" .. sep .. "phpDebug.js" },
	["php-debug-adapter"] = { pkg = "php-debug-adapter", exec = "extension" .. sep .. "out" .. sep .. "phpDebug.js" },
	["js-debug-adapter"] = { pkg = "js-debug-adapter", exec = "js-debug" .. sep .. "src" .. sep .. "dapDebugServer.js" },
	["pwa-node"] = { pkg = "js-debug-adapter", exec = "js-debug" .. sep .. "src" .. sep .. "dapDebugServer.js" },
	["local-lua"] = {
		pkg = "local-lua-debugger-vscode",
		exec = "extension" .. sep .. "extension" .. sep .. "debugAdapter.js",
	},
	["local-lua-debugger-vscode"] = {
		pkg = "local-lua-debugger-vscode",
		exec = "extension" .. sep .. "extension" .. sep .. "debugAdapter.js",
	},
	go = { pkg = "delve", exec = "dlv" },
}

local function is_adapter_installed(adapter)
	local entry = adapter_exec_map[adapter]
	if not entry then
		return true
	end
	local mason_root = vim.env.MASON or (vim.fn.stdpath("data") .. sep .. "mason")
	local path = mason_root .. sep .. "packages" .. sep .. entry.pkg .. sep .. entry.exec
	return vim.uv.fs_stat(path) ~= nil
end

vim.api.nvim_create_user_command("DapContinueChecked", function()
	local session = dap.session()
	local config = session and session.config
	if not config then
		local ft = vim.bo.filetype
		config = dap.configurations[ft] and dap.configurations[ft][1]
	end
	local adapter = config and config.type
	if adapter and not is_adapter_installed(adapter) then
		vim.notify(
			"DAP adapter '"
				.. adapter
				.. "' is still installing (via Mason or custom). Please try again in a few seconds.",
			vim.log.levels.WARN
		)
		return
	end
	dap.continue()
end, {})
