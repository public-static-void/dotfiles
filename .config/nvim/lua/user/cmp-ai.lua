local utils = require("user.utils")

local cmp_ai = utils.safe_require("cmp_ai.config")
if not cmp_ai then
	return
end

local model_configs = {
	["codegemma:2b"] = {
		prompt = function(lines_before, lines_after)
			local file_type = vim.bo.filetype
			return string.format(
				[[
I am an expert %s programmer. Complete the following code, focusing on best practices, efficiency, and readability:

<|fim_prefix|>%s<|fim_suffix|>%s<|fim_middle|>
]],
				file_type,
				lines_before,
				lines_after
			)
		end,
		options = {
			num_predict = 1024,
			temperature = 0.8,
			top_p = 0.95,
			repeat_penalty = 1,
			timeout = 30000,
			stop = { "<|fim_prefix|>", "<|fim_suffix|>", "<|fim_middle|>", "<|file_separator|>" },
			stream = true,
		},
	},
	["codellama:7b-code"] = {
		prompt = function(lines_before, lines_after)
			local file_type = vim.bo.filetype
			return string.format(
				[[
As an expert %s programmer, complete the following code with a focus on best practices, efficiency, and readability:

%s
[Your code here]
%s

Provide a completion that seamlessly integrates with the existing code.
]],
				file_type,
				lines_before,
				lines_after
			)
		end,
		options = {
			num_predict = 2048,
			temperature = 0.7,
			top_p = 0.95,
			repeat_penalty = 1.1,
			timeout = 30000,
			stop = { "[Your code here]", "<|endoftext|>" },
			stream = true,
		},
	},
	["qwen2.5-coder:7b-base-q6_K"] = {
		prompt = function(lines_before, lines_after)
			local file_type = vim.bo.filetype
			return string.format(
				[[
You are an expert %s programmer. Complete the following code, emphasizing best practices, efficiency, and clear, maintainable code:

START_CODE
%s
[COMPLETION]
%s
END_CODE

Provide a completion that logically continues the existing code and adheres to %s coding standards.
]],
				file_type,
				lines_before,
				lines_after,
				file_type
			)
		end,
		options = {
			num_predict = 256,
			temperature = 0.2,
			top_p = 0.95,
			timeout = 30000,
			stop = { "END_CODE" },
			stream = true,
		},
	},
}

-- Setup cmp-ai with a specific model
local function setup_cmp_ai(model)
	local config = {
		max_lines = 300,
		provider = "Ollama",
		notify = true,
		notify_callback = function(msg)
			vim.notify(msg, vim.log.levels.DEBUG)
		end,
		ignored_file_types = {
			-- default is not to ignore
			-- uncomment to ignore in lua:
			-- lua = true
		},
		provider_options = {
			model = model,
			auto_unload = true,
		},
		run_on_every_keystroke = true,
	}

	if model_configs[model] then
		config.provider_options.prompt = model_configs[model].prompt
		config.provider_options.options = model_configs[model].options
	else
		print("No specific configuration for model: " .. model .. ". Using default settings.")
	end

	-- Wrap the setup in a protected call
	local status_ok, err = pcall(function()
		cmp_ai:setup(config)
	end)

	if not status_ok then
		vim.notify("Failed to set up cmp-ai: " .. tostring(err), vim.log.levels.ERROR)
	end
end

-- Custom command to select a model for cmp-ai
vim.api.nvim_create_user_command("ModelCmp", function()
	if utils.is_ollama_available() then
		local available_models = utils.get_available_models("cmp-ai")
		if #available_models > 0 then
			utils.select_model(available_models, "cmp-ai", setup_cmp_ai)
		else
			print("No models available")
		end
	else
		print("Ollama is not available. cmp-ai cannot be set up.")
	end
end, {})

-- Initial setup with preferred model
if utils.is_ollama_available() then
	utils.use_or_select_model("cmp-ai", setup_cmp_ai)
else
	print("Ollama is not available. cmp-ai will not be set up.")
end
