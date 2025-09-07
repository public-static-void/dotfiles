--- DAP adapter setup for various languages.
--- Defines official DAP adapters using Mason paths or custom commands.
--- Includes extended in-file documentation for complex adapters (e.g., PHP).
--- @module user.dap.adapters
local utils = require("user.utils")

local dap = utils.safe_require("dap")
if not dap then
	return
end

local sep = package.config:sub(1, 1)
local mason_adapter_path = utils.mason_adapter_path
local is_windows = utils.is_windows

-- Java adapter setup is managed externally (e.g., jdtls).

--- Codelldb Adapter for C, C++, Rust
dap.adapters.codelldb = {
	type = "server",
	host = "127.0.0.1",
	port = "${port}",
	executable = {
		command = mason_adapter_path("codelldb", "extension" .. sep .. "adapter" .. sep .. "codelldb"),
		args = { "--port", "${port}" },
	},
}

--- Python adapter using debugpy installed by Mason.
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

--- Go adapter using delve with DAP support.
dap.adapters.go = {
	type = "server",
	port = "${port}",
	executable = {
		command = mason_adapter_path("delve", "dlv"),
		args = { "dap", "-l", "127.0.0.1:${port}" },
	},
}

--- PHP adapter (php-debug-adapter) with detailed setup notes.
---
--- ## Prerequisites:
--- - PHP interpreter installed (`pacman -S php` or equivalent).
--- - Xdebug extension installed and enabled (`pacman -S xdebug`).
--- - Proper configuration in your `php.ini` or `xdebug.ini`:
--- ```
--- zend_extension=xdebug.so
--- xdebug.mode=debug
--- xdebug.start_with_request=yes
--- xdebug.client_host=127.0.0.1
--- xdebug.client_port=9003
--- xdebug.remote_enable=1
--- xdebug.remote_autostart=1
--- ```
--- This adapter depends on Node.js to run the debug server.
dap.adapters.php = {
	type = "executable",
	command = "node",
	args = { mason_adapter_path("php-debug-adapter", "extension" .. sep .. "out" .. sep .. "phpDebug.js") },
}

--- JavaScript/TypeScript "pwa-node" adapter using Node internally.
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

--- Lua adapter using the local-lua-debugger-vscode extension.
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

return dap.adapters
