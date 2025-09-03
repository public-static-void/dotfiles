local utils = require("user.utils")

local runner = utils.safe_require("code_runner")
if not runner then
	return
end

local is_windows = vim.fn.has("win32") == 1
local path_sep = is_windows and "\\" or "/"
local tmp_dir = is_windows and os.getenv("TMP") or "/tmp"

-- Use ";" for command chaining on Windows (PowerShell compatible),
-- "&&" on Unix-like systems for proper command execution flow.
local shell_and = is_windows and ";" or "&&"

runner.setup({
	filetype = {
		java = {
			"cd $dir" .. shell_and,
			"javac $fileName" .. shell_and,
			"java $fileNameWithoutExt",
		},
		python = "python3 -u",
		rust = {
			"cd $dir" .. shell_and,
			"rustc $fileName" .. shell_and,
			"$dir" .. path_sep .. "$fileNameWithoutExt",
		},
		c = function()
			print("asd")
			local output = tmp_dir .. path_sep .. vim.fn.expand("%:t:r") .. (is_windows and ".exe" or "")
			local c_base = {
				"cd $dir" .. shell_and,
				"gcc $fileName -o " .. output,
			}
			local c_exec = {
				shell_and .. " " .. output .. shell_and,
				(is_windows and ("del " .. output) or ("rm " .. output)),
			}
			require("code_runner.commands").run_from_fn(vim.list_extend(c_base, c_exec))
		end,
		javascript = "node %",
		sh = is_windows and "bash %" or "sh %",
		ruby = "ruby %",
	},
})

local cmds = require("code_runner.commands")

local custom_runners = {
	typescript = function()
		local file = vim.fn.expand("%:p")
		cmds.run_from_fn({ "deno", "run", file })
	end,
	lua = function()
		local file = vim.fn.expand("%:p")
		cmds.run_from_fn({ "lua", file })
	end,
	php = function()
		local file = vim.fn.expand("%:p")
		-- Disable Xdebug flag to avoid debug connection issues during run
		cmds.run_from_fn({ "php", "-d", "xdebug.mode=off", file })
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
		local dir = vim.fn.expand("%:p:h")
		local file = vim.fn.expand("%:t")
		cmds.run_from_fn({
			"cd",
			dir,
			shell_and,
			"perl",
			file,
		})
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
function M.run_file()
	local ft = vim.bo.filetype
	if custom_runners[ft] then
		custom_runners[ft]()
	else
		runner.run_filetype()
	end
end

return M
