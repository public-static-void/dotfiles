local mason_dap_packages = {
	"python",
	"codelldb",
	"delve",
	"js",
	"php",
}

--  Custom DAPs (not in Mason)
local custom_dap_packages = {
	"local-lua-debugger-vscode",
}

-- Mason auto-install for official DAPs
require("mason").setup()
require("mason-nvim-dap").setup({
	ensure_installed = mason_dap_packages,
	automatic_installation = true,
})

-- Custom installer for non-Mason DAPs
local mason_registry_ok, mason_registry = pcall(require, "mason-registry")
if not mason_registry_ok or not mason_registry then
	vim.notify("Mason Registry could not be loaded. Check your Mason setup.", vim.log.levels.ERROR)
	return
end

local function custom_install_adapter(adapter)
	local ok, package = pcall(mason_registry.get_package, adapter)
	if ok and package and not package:is_installed() then
		vim.schedule(function()
			vim.notify("[custom-dap] installing " .. adapter, vim.log.levels.INFO)
		end)
		package:install():once("closed", function()
			vim.schedule(function()
				if package:is_installed() then
					vim.notify("[custom-dap] " .. adapter .. " was installed", vim.log.levels.INFO)
				else
					vim.notify("[custom-dap] failed to install " .. adapter, vim.log.levels.ERROR)
				end
			end)
		end)
	end
end

vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		for _, adapter in ipairs(custom_dap_packages) do
			custom_install_adapter(adapter)
		end
	end,
})

-- DAP UI and virtual text
local dap = require("dap")
local dapui = require("dapui")
dapui.setup()
require("nvim-dap-virtual-text").setup({})

-- Helper for Mason adapter path
local function mason_adapter_path(pkg, subpath)
	local root = vim.env.MASON or (vim.fn.stdpath("data") .. "/mason")
	local path = root .. "/packages/" .. pkg .. "/" .. subpath
	if vim.loop.fs_stat(path) then
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

-- DAP Adapters and Configurations

-- C/C++/Rust (codelldb)
dap.adapters.codelldb = {
	type = "server",
	host = "127.0.0.1",
	port = "${port}",
	executable = {
		command = mason_adapter_path("codelldb", "extension/adapter/codelldb"),
		args = { "--port", "${port}" },
	},
}
dap.configurations.c = {
	{
		name = "Launch file",
		type = "codelldb",
		request = "launch",
		program = async_program_builder(function()
			local current_file = vim.fn.expand("%:p")
			local output_binary = "./build/" .. vim.fn.fnamemodify(current_file, ":t:r")
			return string.format("mkdir -p build && gcc %s -g -o %s", current_file, output_binary)
		end, function()
			local current_file = vim.fn.expand("%:p")
			local output_binary = "./build/" .. vim.fn.fnamemodify(current_file, ":t:r")
			return string.format("find ./build -maxdepth 1 -type f -name '%s'", vim.fn.fnamemodify(output_binary, ":t"))
		end),
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
	},
}
dap.configurations.cpp = {
	{
		name = "Launch file",
		type = "codelldb",
		request = "launch",
		program = async_program_builder(function()
			local current_file = vim.fn.expand("%:p")
			local output_binary = "./build/" .. vim.fn.fnamemodify(current_file, ":t:r")
			return string.format("mkdir -p build && g++ %s -g -o %s", current_file, output_binary)
		end, function()
			local current_file = vim.fn.expand("%:p")
			local output_binary = "./build/" .. vim.fn.fnamemodify(current_file, ":t:r")
			return string.format("find ./build -maxdepth 1 -type f -name '%s'", vim.fn.fnamemodify(output_binary, ":t"))
		end),
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
	},
}
dap.configurations["c++"] = dap.configurations.cpp
dap.configurations["cc"] = dap.configurations.cpp
dap.configurations.rust = {
	{
		name = "Launch file",
		type = "codelldb",
		request = "launch",
		program = async_program_builder(function()
			return "cargo build"
		end, function()
			return "find ./target/debug -maxdepth 1 -type f -executable"
		end),
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
	},
}

-- Python (debugpy)
dap.adapters.python = {
	type = "executable",
	command = mason_adapter_path("debugpy", "venv/bin/python"),
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
			if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
				return cwd .. "/venv/bin/python"
			elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
				return cwd .. "/.venv/bin/python"
			else
				return mason_adapter_path("debugpy", "venv/bin/python")
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
	args = { mason_adapter_path("php-debug-adapter", "extension/out/phpDebug.js") },
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
			mason_adapter_path("js-debug-adapter", "js-debug/src/dapDebugServer.js"),
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
		mason_adapter_path("local-lua-debugger-vscode", "extension/extension/debugAdapter.js"),
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

-- 9. Custom breakpoint color and sign
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

-- 10. DAP UI open/close logic
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

-- 11. (Optional) DapContinueChecked command as before
local adapter_exec_map = {
	codelldb = { pkg = "codelldb", exec = "extension/adapter/codelldb" },
	python = { pkg = "debugpy", exec = "venv/bin/python" },
	delve = { pkg = "delve", exec = "dlv" },
	php = { pkg = "php-debug-adapter", exec = "extension/out/phpDebug.js" },
	["php-debug-adapter"] = { pkg = "php-debug-adapter", exec = "extension/out/phpDebug.js" },
	["js-debug-adapter"] = { pkg = "js-debug-adapter", exec = "js-debug/src/dapDebugServer.js" },
	["pwa-node"] = { pkg = "js-debug-adapter", exec = "js-debug/src/dapDebugServer.js" },
	["local-lua"] = { pkg = "local-lua-debugger-vscode", exec = "extension/extension/debugAdapter.js" },
	["local-lua-debugger-vscode"] = { pkg = "local-lua-debugger-vscode", exec = "extension/extension/debugAdapter.js" },
	go = { pkg = "delve", exec = "dlv" },
}

local function is_adapter_installed(adapter)
	local entry = adapter_exec_map[adapter]
	if not entry then
		return true
	end
	local mason_root = vim.env.MASON or (vim.fn.stdpath("data") .. "/mason")
	local path = mason_root .. "/packages/" .. entry.pkg .. "/" .. entry.exec
	return vim.loop.fs_stat(path) ~= nil
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
