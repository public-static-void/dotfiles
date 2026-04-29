--- Language-specific dap configurations.
--- Each language’s launch configurations with detailed setup including asynchronous prog builders.
--- Implements multi-language support and dynamic runtime executable resolution for Python virtual environments.
--- @module "user.dap.configs"
local utils = require("user.utils")

local dap = utils.safe_require("dap")
if not dap then
	return
end

local sep = package.config:sub(1, 1)
local async_program_builder = utils.async_program_builder
local mason_adapter_path = utils.mason_adapter_path
local is_windows = utils.is_windows

--- Java
dap.configurations.java = {
	{
		type = "java",
		request = "launch",
		name = "Launch Java Main Class",
		program = "${file}",
		cwd = vim.fn.getcwd(),
		console = "internalConsole",
	},
}

--- C++ / C using codelldb and gcc for build.
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
dap.configurations.c = dap.configurations.cpp

--- Rust configuration using cargo build tooling.
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
				return string.format("find .%starget%sdebug -maxdepth 1 -type f -executable", sep, sep)
			end
		end),
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
	},
}

--- Python debugging with dynamic resolution of virtualenv python executable.
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

--- Go debugging configuration.
dap.configurations.go = {
	{
		name = "Debug main.go",
		type = "go",
		request = "launch",
		program = "${file}",
	},
}

--- PHP debugging configuration.
---
--- PHP requires PHP and Xdebug installed & configured properly.
--- Please ensure your php.ini or xdebug.ini has these directives:
--- ```
--- zend_extension=xdebug.so
--- xdebug.mode=debug
--- xdebug.start_with_request=yes
--- xdebug.client_host=127.0.0.1
--- xdebug.client_port=9003
--- xdebug.remote_enable=1
--- xdebug.remote_autostart=1
--- ```
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

--- JavaScript / TypeScript debugging configurations.
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

--- Lua debugging configuration.
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

return dap.configurations
