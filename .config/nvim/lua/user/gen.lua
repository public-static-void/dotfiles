-- gen.lua
local utils = require("user.utils")

local gen = utils.safe_require("gen")
if not gen then
	return
end

local host = utils.host
local port = utils.port

-- Setup gen with a specific model
local function setup_gen(model)
	gen.setup({
		model = model,
		quit_map = "q",
		retry_map = "<c-r>",
		accept_map = "<c-cr>",
		host = host,
		port = port,
		display_mode = "float",
		show_prompt = false,
		show_model = false,
		no_auto_close = false,
		file = false,
		hidden = false,
		init = function()
			io.popen("ollama serve > /dev/null 2>&1 &")
		end,
		command = function()
			local body = { model = model, stream = true }
			return "curl --silent --no-buffer -X POST http://"
				.. host
				.. ":"
				.. port
				.. "/api/chat -d '"
				.. vim.json.encode(body)
				.. "'"
		end,
		result_filetype = "markdown",
		debug = false,
	})
end

-- Custom command to select a model for gen
vim.api.nvim_create_user_command("ModelGen", function()
	local available_models = utils.get_available_models()
	if #available_models > 0 then
		utils.select_model(available_models, "gen.nvim", setup_gen)
	else
		print("No models available")
	end
end, {})

-- Initial setup with preferred model
utils.use_or_select_model("gen.nvim", setup_gen)
