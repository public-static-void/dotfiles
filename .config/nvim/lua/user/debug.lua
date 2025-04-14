local utils = require("user.utils")

-- Safely load required modules
local dap = utils.safe_require("dap")
if not dap then
	return
end

local dap_utils = utils.safe_require("dap.utils")
if not dap_utils then
	return
end

local mason = utils.safe_require("mason")
if not mason then
	return
end

local mason_registry_ok, mason_registry = pcall(require, "mason-registry")
if not mason_registry_ok or not mason_registry then
	vim.notify("Mason Registry could not be loaded. Check your Mason setup.", vim.log.levels.ERROR)
	return
end

local mason_nvim_dap = utils.safe_require("mason-nvim-dap")
if not mason_nvim_dap then
	return
end

local dapui = utils.safe_require("dapui")
if not dapui then
	return
end

local dap_virtual_text = utils.safe_require("nvim-dap-virtual-text")
if not dap_virtual_text then
	return
end

-- Dap Virtual Text
dap_virtual_text.setup()

-- List of adapters
local adapters = {
	"debugpy",
	"codelldb",
	"delve",
	"php-debug-adapter",
	"js-debug-adapter",
	"local-lua-debugger-vscode",
}

-- Auto-install missing adapters on startup using the adapter list
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		local missing_adapters = {} -- Collect missing adapters for batch notification

		for _, adapter in ipairs(adapters) do
			local ok, package = pcall(mason_registry.get_package, adapter)
			if ok and package then
				if not package:is_installed() then
					vim.schedule(function()
						vim.notify("Installing missing adapter: " .. adapter, vim.log.levels.INFO)
					end)
					package:install():once("closed", function()
						vim.schedule(function()
							if package:is_installed() then
								vim.notify("Successfully installed adapter: " .. adapter, vim.log.levels.INFO)
							else
								vim.notify("Failed to install adapter: " .. adapter, vim.log.levels.ERROR)
							end
						end)
					end)
				end
			else
				table.insert(missing_adapters, adapter)
			end
		end
	end,
})

-- Mason DAP setup
mason_nvim_dap.setup({
	ensure_installed = adapters,
	automatic_installation = true,
	handlers = {
		function(config)
			require("mason-nvim-dap").default_setup(config)
		end,
	},
})

-- Function to build C/C++/Rust projects and find executables
local function build_and_find_executable(build_command, find_command)
	-- Run the build command and capture its output
	local handle = io.popen(build_command .. " 2>&1")
	if not handle then
		error("Failed to execute: " .. build_command)
	end

	local result = handle:read("*a")
	handle:close()

	-- Print the build output to the command-line window
	vim.cmd("echo ''") -- Clear any existing messages
	for _, line in ipairs(vim.split(result, "\n", { trimempty = true })) do
		vim.cmd(string.format("echo '%s'", vim.fn.escape(line, "'")))
	end

	-- Locate the resulting executable
	local find_handle = io.popen(find_command)
	if not find_handle then
		error("Failed to execute: " .. find_command)
	end

	local find_result = find_handle:read("*a")
	find_handle:close()

	local executables = vim.split(find_result, "\n", { trimempty = true })
	if #executables == 0 then
		error(string.format("No executable found for %s. Compilation might have failed."))
	elseif #executables == 1 then
		return executables[1] -- Return the path to the single executable
	else
		-- If multiple executables are found, prompt the user to select one
		local choices = { "Select an executable:" }
		for i, executable in ipairs(executables) do
			table.insert(choices, string.format("%d: %s", i, executable))
		end

		local choice = vim.fn.inputlist(choices)
		if choice > 0 and executables[choice] then
			return executables[choice]
		else
			error("No valid executable selected.")
		end
	end
end

-- Configurations for supported languages

-- C/C++/Rust
dap.adapters.codelldb = {
	type = "server",
	host = "127.0.0.1",
	port = "${port}",
	executable = {
		command = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/codelldb",
		args = { "--port", "${port}" },
	},
}

-- C
dap.configurations.c = {
	{
		name = "Launch file",
		type = "codelldb",
		request = "launch",
		program = function()
			local current_file = vim.fn.expand("%:p") -- Full path of the current file
			local output_binary = "./build/" .. vim.fn.fnamemodify(current_file, ":t:r") -- Output binary path

			-- Custom message for feedback
			vim.cmd(string.format("echo 'Compiling %s to %s'", current_file, output_binary))

			return build_and_find_executable(
				string.format("mkdir -p build && gcc %s -g -o %s 2>&1", current_file, output_binary), -- Build command for C
				string.format("find ./build -maxdepth 1 -type f -name '%s'", vim.fn.fnamemodify(output_binary, ":t")) -- Find command for binary
			)
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
	},
}

-- C++
dap.configurations.cpp = {
	{
		name = "Launch file",
		type = "codelldb",
		request = "launch",
		program = function()
			local current_file = vim.fn.expand("%:p") -- Full path of the current file
			local output_binary = "./build/" .. vim.fn.fnamemodify(current_file, ":t:r") -- Output binary path

			-- Custom message for feedback
			vim.cmd(string.format("echo 'Compiling %s to %s'", current_file, output_binary))

			return build_and_find_executable(
				string.format("mkdir -p build && g++ %s -g -o %s 2>&1", current_file, output_binary), -- Build command for C++
				string.format("find ./build -maxdepth 1 -type f -name '%s'", vim.fn.fnamemodify(output_binary, ":t")) -- Find command for binary
			)
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
	},
}

-- Rust
dap.configurations.rust = {
	{
		name = "Launch file",
		type = "codelldb",
		request = "launch",
		program = function()
			return build_and_find_executable(
				"cargo build", -- Build command for Rust
				string.format("find ./target/debug -maxdepth 1 -type f -executable") -- Find command for Rust binaries in `target/debug`
			)
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
	},
}

-- Python
local dap_python = utils.safe_require("dap-python")
if dap_python then
	dap_python.setup(vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python")
	dap.configurations.python = {
		{
			name = "Launch file",
			type = "python",
			request = "launch",
			program = "${file}",
			cwd = vim.fn.getcwd(),
			console = "integratedTerminal",
		},
	}
end

-- Golang
local dap_go = utils.safe_require("dap-go")
if dap_go then
	dap_go.setup()
	dap.configurations.go = {
		{
			name = "Debug main.go",
			type = "delve",
			request = "launch",
			program = "${file}",
		},
	}
end

-- PHP

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
	args = { vim.fn.stdpath("data") .. "/mason/packages/php-debug-adapter/extension/out/phpDebug.js" },
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

-- JS/TS
dap.adapters["pwa-node"] = {
	type = "server",
	host = "localhost",
	port = "${port}",
	executable = {
		command = "node",
		args = {
			vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
			"${port}",
		},
	},
}
-- Supported languages
local js_based_languages = { "typescript", "javascript" }
-- NOTE: Requires tsx installed globally (i.e. `npm install -g tsx`)
for _, language in ipairs(js_based_languages) do
	dap.configurations[language] = {
		-- Launch file configuration
		{
			type = "pwa-node",
			request = "launch",
			name = "Launch file",
			program = "${file}",
			runtimeExecutable = "tsx", -- Use tsx runtime (must be globally installed)
			cwd = "${workspaceFolder}",
			sourceMaps = true,
			resolveSourceMapLocations = { "${workspaceFolder}/**", "!**/node_modules/**" },
			console = "integratedTerminal", -- Use the integrated terminal for output
			internalConsoleOptions = "neverOpen", -- Prevent opening the debug console
			skipFiles = { "<node_internals>/**", "${workspaceFolder}/node_modules/**" },
		},
	}
end

-- Lua
dap.adapters["local-lua"] = {
	type = "executable",
	command = "node",
	args = {
		vim.fn.stdpath("data") .. "/mason/packages/local-lua-debugger-vscode/extension/extension/debugAdapter.js",
	},
	enrich_config = function(config, on_config)
		config.extensionPath = vim.fn.stdpath("data") .. "/mason/packages/local-lua-debugger-vscode/extension"
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

-- Dap UI

dapui.setup()

-- Function to set highlight group dynamically
local function set_dap_breakpoint_color()
	local fallback_color = "#E82424" -- VSCode red color

	-- Try to get the default error color from the current colorscheme
	local ok, hl_error = pcall(vim.api.nvim_get_hl_by_name, "Error", true)

	if ok and hl_error.foreground then
		-- Use the foreground color of the "Error" highlight group
		vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = string.format("#%06x", hl_error.foreground) })
	else
		-- Fallback to VSCode red if "Error" group is not available
		vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = fallback_color })
	end

	-- Define the DapBreakpoint sign with the custom highlight group
	vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint" })
end

-- Call the function
set_dap_breakpoint_color()

-- Open/close DAP UI automatically on events
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
