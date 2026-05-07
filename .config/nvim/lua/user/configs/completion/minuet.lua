local utils = require("user.utils")
local llm_server = require("user.configs.completion.llm_server")

local minuet = utils.safe_require("minuet")
if not minuet then
	return
end

local model = llm_server.model
local is_windows = vim.loop.os_uname().sysname == "Windows_NT"
local api_key_env = is_windows and "APPDATA" or "TERM"

minuet.setup({
	provider = llm_server.reachable() and "openai_fim_compatible" or nil,
	n_completions = 1,
	context_window = 4096,
	throttle = 2000,
	debounce = 1000,
	provider_options = {
		openai_fim_compatible = {
			api_key = api_key_env,
			name = "llama.cpp",
			end_point = llm_server.base_url .. "/v1/completions",
			model = model,
			request_timeout = 30,
			optional = {
				max_tokens = 256,
				stop = { "\n\n" },
				top_p = 0.9,
			},
		},
	},
})
