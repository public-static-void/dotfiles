local utils = require("user.utils")

local minuet = utils.safe_require("minuet")
if not minuet then
	return
end

local is_windows = vim.loop.os_uname().sysname == "Windows_NT"
local api_key_env = is_windows and "APPDATA" or "TERM"

minuet.setup({
	provider = "openai_fim_compatible",
	n_completions = 1,
	context_window = 4096,
	throttle = 2000,
	debounce = 1000,
	provider_options = {
		openai_fim_compatible = {
			api_key = api_key_env,
			name = "Ollama",
			end_point = "http://localhost:11434/v1/completions",
			model = "qwen2.5-coder:1.5b-instruct",
			request_timeout = 30,
			optional = {
				max_tokens = 256,
				stop = { "\n\n" },
				top_p = 0.9,
			},
		},
	},
})
