local utils = require("user.utils")

local cmp_ai = utils.safe_require("cmp_ai.config")
if not cmp_ai then
	return
end

-- Shared prompt template generator
local function generate_prompt(template, lines_before, lines_after)
	local file_type = vim.bo.filetype
	return string.format(template, file_type, lines_before, lines_after)
end

-- Shared options for models
local default_options = {
	num_predict = 2048,
	temperature = 0.7,
	top_p = 0.95,
	repeat_penalty = 1.1,
	timeout = 30000,
	stream = true,
}

-- Stop sequences for different models
local stop_sequences = {
	default = { "<|endoftext|>" },
	code_completion = { "[Your code here]", "<|endoftext|>" },
	fim_prefix = { "<|fim_prefix|>", "<|fim_suffix|>", "<|fim_middle|>", "<|file_separator|>" },
}

-- Model-specific configurations
local model_configs = {
	["codellama:34b-code"] = {
		prompt = function(lines_before, lines_after)
			return generate_prompt(
				[[
I am an expert %s programmer. Complete the following code, focusing on best practices, efficiency, and readability:

<|fim_prefix|>%s<|fim_suffix|>%s<|fim_middle|>
]],
				lines_before,
				lines_after
			)
		end,
		options = vim.tbl_extend("keep", default_options, {
			stop = stop_sequences.fim_prefix,
		}),
	},
	["codellama:13b-code"] = {
		prompt = function(lines_before, lines_after)
			return generate_prompt(
				[[
As an expert %s programmer, complete the following code with a focus on best practices, efficiency, and readability:

%s
[Your code here]
%s

Provide a completion that seamlessly integrates with the existing code.
]],
				lines_before,
				lines_after
			)
		end,
		options = vim.tbl_extend("keep", default_options, {
			temperature = 0.75,
			top_p = 0.9,
			stop = stop_sequences.code_completion,
		}),
	},
	["codellama:34b"] = {
		prompt = function(lines_before, lines_after)
			return generate_prompt(
				[[
You are an expert %s programmer. Complete the following code:

%s
%s
]],
				lines_before,
				lines_after
			)
		end,
		options = vim.tbl_extend("keep", default_options, {
			temperature = 0.6,
			repeat_penalty = 1.2,
			stop = stop_sequences.default,
		}),
	},
	["codellama:13b"] = {
		prompt = function(lines_before, lines_after)
			return generate_prompt(
				[[
As an expert %s programmer, complete the following code:

%s
%s
]],
				lines_before,
				lines_after
			)
		end,
		options = vim.tbl_extend("keep", default_options, {
			temperature = 0.65,
			stop = stop_sequences.default,
		}),
	},
	["codellama:7b-code"] = {
		prompt = function(lines_before, lines_after)
			return generate_prompt(
				[[
As an expert %s programmer, complete the following code with a focus on best practices, efficiency, and readability:

%s
[Your code here]
%s

Provide a completion that seamlessly integrates with the existing code.
]],
				lines_before,
				lines_after
			)
		end,
		options = vim.tbl_extend("keep", default_options, {
			stop = stop_sequences.code_completion,
		}),
	},
	["llama3:latest"] = {
		prompt = function(lines_before, lines_after)
			return generate_prompt(
				[[
You are an expert %s programmer. Complete the following code:

%s
%s
]],
				lines_before,
				lines_after
			)
		end,
		options = vim.tbl_extend("keep", default_options, {
			temperature = 0.5,
			repeat_penalty = 1.2,
			stop = stop_sequences.default,
		}),
	},
	["llama3:8b"] = {
		prompt = function(lines_before, lines_after)
			return generate_prompt(
				[[
You are an expert %s programmer. Complete the following code:

%s
%s
]],
				lines_before,
				lines_after
			)
		end,
		options = vim.tbl_extend("keep", default_options, {
			temperature = 0.6,
			repeat_penalty = 1.2,
			stop = stop_sequences.default,
		}),
	},
	["deepseek-coder:6.7b-base"] = {
		prompt = function(lines_before, lines_after)
			return generate_prompt(
				[[
You are an expert %s programmer. Complete the following code:

%s
%s
]],
				lines_before,
				lines_after
			)
		end,
		options = vim.tbl_extend("keep", default_options, {
			temperature = 0.65,
			repeat_penalty = 1.2,
			stop = stop_sequences.default,
		}),
	},
	["codellama:latest"] = {
		prompt = function(lines_before, lines_after)
			return generate_prompt(
				[[
You are an expert %s programmer. Complete the following code:

%s
%s
]],
				lines_before,
				lines_after
			)
		end,
		options = vim.tbl_extend("keep", default_options, {
			temperature = 0.5,
			repeat_penalty = 1.2,
			stop = stop_sequences.default,
		}),
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
		ignored_file_types = {},
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
