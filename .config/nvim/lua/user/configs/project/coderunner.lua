--- Provides customizable code running capabilities integrated with code_runner.nvim.
--- Defines filetype-specific runners that may include build, execute, and cleanup steps.
--- Handles platform differences (Windows vs Unix) with proper shell command chaining.
--- Falls back to code_runner.nvim's default runner when no custom runner is specified.
---
--- Public API:
--- - `run_file()`: runs the current buffer using the appropriate runner.
---
--- Usage:
--- ```
--- local coderunner = require("user.coderunner")
--- coderunner.run_file()
--- ```
---
--- @module user.coderunner
local utils = require("user.utils")

local runner = utils.safe_require("code_runner")
local cmds = utils.safe_require("code_runner.commands")
if not runner or not cmds then
	return
end

local is_windows = vim.fn.has("win32") == 1
local path_sep = is_windows and "\\" or "/"
local tmp_dir = is_windows and os.getenv("TMP") or "/tmp"
local shell_and = is_windows and ";" or "&&"

--- Join commands using platform-appropriate shell operator.
--- @param cmds string|string[] A single command string or a list of commands.
--- @return string A single shell command string with commands chained properly.
local function chain_cmds(cmds)
	if type(cmds) == "string" then
		return cmds
	end
	return table.concat(cmds, " " .. shell_and .. " ")
end

--- Filetype specific runners.
--- Can be:
--- - string: simple command string passed to code_runner's default runner
--- - table: must have `.cmds` list of shell commands chained for build+run
--- - function: custom Lua runner logic
local custom_runners = {
	java = {
		cmds = {
			'cd "$dir"',
			"javac $fileName",
			"java $fileNameWithoutExt",
		},
	},
	python = "python3 -u %",
	rust = {
		cmds = {
			'cd "$dir"',
			"rustc $fileName",
			"$dir" .. path_sep .. "$fileNameWithoutExt",
		},
	},
	c = function()
		local output = tmp_dir .. path_sep .. vim.fn.expand("%:t:r") .. (is_windows and ".exe" or "")
		local c_base = {
			"cd $dir" .. shell_and,
			"gcc $fileName -o " .. output,
		}
		local c_exec = {
			shell_and .. " " .. output .. shell_and,
			(is_windows and ("del " .. output) or ("rm " .. output)),
		}
		cmds.run_from_fn(vim.list_extend(c_base, c_exec))
	end,
	javascript = "node %",
	sh = is_windows and "bash %" or "sh %",
	ruby = "ruby %",
	typescript = function()
		cmds.run_from_fn({ "deno", "run", vim.fn.expand("%:p") })
	end,
	lua = function()
		cmds.run_from_fn({ "lua", vim.fn.expand("%:p") })
	end,
	php = function()
		cmds.run_from_fn({ "php", "-d", "xdebug.mode=off", vim.fn.expand("%:p") })
	end,
	go = function()
		local dir = vim.fn.expand("%:p:h")
		local file = vim.fn.expand("%:t")
		local output = tmp_dir .. path_sep .. vim.fn.expand("%:t:r") .. (is_windows and ".exe" or "")
		cmds.run_from_fn({
			"cd",
			dir,
			shell_and,
			"go",
			"build",
			"-o",
			output,
			file,
			shell_and,
			output,
		})
		vim.loop.fs_unlink(output)
	end,
	haskell = function()
		local dir = vim.fn.expand("%:p:h")
		local file = vim.fn.expand("%:t")
		local output = tmp_dir .. path_sep .. vim.fn.expand("%:t:r") .. (is_windows and ".exe" or "")
		cmds.run_from_fn({
			"cd",
			dir,
			shell_and,
			"ghc",
			"-o",
			output,
			file,
			shell_and,
			output,
		})
		vim.loop.fs_unlink(output)
	end,
	perl = function()
		cmds.run_from_fn({ "perl", vim.fn.expand("%:p") })
	end,
	kotlin = function()
		local dir = vim.fn.expand("%:p:h")
		local file = vim.fn.expand("%:t")
		local output = tmp_dir .. path_sep .. vim.fn.expand("%:t:r") .. ".jar"
		cmds.run_from_fn({
			"cd",
			dir,
			shell_and,
			"kotlinc",
			file,
			"-include-runtime",
			"-d",
			output,
			shell_and,
			"java -jar " .. output,
		})
		vim.loop.fs_unlink(output)
	end,
}

local M = {}

--- Runs the current buffer using a custom runner if defined for its filetype,
--- otherwise falls back to the default code_runner.nvim runner.
--- @return nil
function M.run_file()
	local ft = vim.bo.filetype
	local handler = custom_runners[ft]
	if type(handler) == "function" then
		handler()
	elseif type(handler) == "table" and handler.cmds then
		local cmd_str = chain_cmds(handler.cmds)
		cmds.run_from_fn({ cmd_str })
	else
		runner.run_filetype()
	end
end

return M
