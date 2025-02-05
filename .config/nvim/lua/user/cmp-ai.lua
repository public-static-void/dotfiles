-- cmp-ai.lua
local utils = require("user.utils")

local cmp_ai = utils.safe_require("cmp_ai.config")
if not cmp_ai then
	return
end

-- Setup cmp-ai with a specific model
local function setup_cmp_ai(model)
	local config = {
		max_lines = 100,
		provider = "Ollama",
		notify = true,
		notify_callback = function(msg)
			vim.notify(msg)
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
		run_on_every_keystroke = false,
	}

	-- Model-specific configurations
	if model == "codegemma:2b-code" then
		config.provider_options.prompt = function(lines_before)
			return lines_before
		end
		config.provider_options.suffix = function(lines_after)
			return lines_after
		end
	elseif model == "qwen2.5-coder:7b-base-q6_K" then
		config.provider_options.prompt = function(lines_before, lines_after)
			return "<|fim_prefix|>" .. lines_before .. "<|fim_suffix|>" .. lines_after .. "<|fim_middle|>"
		end
	end
	cmp_ai:setup(config)
end

-- Custom command to select a model for cmp-ai
vim.api.nvim_create_user_command("ModelCmp", function()
	local available_models = utils.get_available_models()
	if #available_models > 0 then
		utils.select_model(available_models, "cmp-ai", setup_cmp_ai)
	else
		print("No models available")
	end
end, {})

-- Initial setup with preferred model
utils.use_or_select_model("cmp-ai", setup_cmp_ai)
