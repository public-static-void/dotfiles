local utils = require("user.utils")

local minuet = utils.safe_require("minuet")
if not minuet then
	return
end

minuet.setup({
	provider = "openai_fim_compatible",
	n_completions = 1,
	context_window = 4096,
	throttle = 2000,
	debounce = 1000,
	provider_options = {
		openai_fim_compatible = {
			-- For Windows users, TERM may not be present in environment variables.
			-- Consider using APPDATA instead.
			api_key = "TERM",
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
