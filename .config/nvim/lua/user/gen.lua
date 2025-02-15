local utils = require("user.utils")

local gen = utils.safe_require("gen")
if not gen then
	return
end

local host = utils.host
local port = utils.port

-- Model-specific configurations
local model_configs = {
	default = {
		quit_map = "q",
		retry_map = "<c-r>",
		accept_map = "<c-cr>",
		display_mode = "float",
		show_prompt = false,
		show_model = false,
		no_auto_close = false,
		file = false,
		hidden = false,
		result_filetype = "markdown",
		debug = false,
	},
	-- Add model-specific configurations here if needed
	-- ["model_name"] = { ... },
}

-- Setup gen with a specific model
local function setup_gen(model)
	if not utils.is_ollama_available() then
		print("Ollama is not available. Gen.nvim will not be set up.")
		return
	end

	local config = vim.tbl_deep_extend("force", model_configs.default, model_configs[model] or {})
	config.model = model
	config.host = host
	config.port = port

	config.command = function()
		local body = { model = model, stream = true }
		return string.format(
			"curl --silent --no-buffer -X POST http://%s:%s/api/chat -d '%s'",
			host,
			port,
			vim.json.encode(body)
		)
	end

	-- Wrap the setup in a protected call
	local status_ok, err = pcall(function()
		gen.setup(config)
	end)

	if not status_ok then
		vim.notify("Failed to set up gen.nvim: " .. tostring(err), vim.log.levels.ERROR)
	end
end

-- Custom command to select a model for gen
vim.api.nvim_create_user_command("ModelGen", function()
	if utils.is_ollama_available() then
		local available_models = utils.get_available_models("gen.nvim")
		if #available_models > 0 then
			utils.select_model(available_models, "gen.nvim", setup_gen)
		else
			print("No models available")
		end
	else
		print("Ollama is not available. Gen.nvim cannot be set up.")
	end
end, {})

-- Initial setup with preferred model
if utils.is_ollama_available() then
	utils.use_or_select_model("gen.nvim", setup_gen)
else
	print("Ollama is not available. Gen.nvim will not be set up.")
end
