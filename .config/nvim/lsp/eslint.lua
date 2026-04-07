local utils = require("user.utils")

local handlers = utils.safe_require("user.configs.lsp.handlers")
if not handlers then
	return
end

--- Filetypes that this ESLint LSP server will attach to.
local filetypes = {
	"javascript",
	"javascriptreact",
	"typescript",
	"typescriptreact",
	"vue",
	"svelte",
	"astro",
	"htmlangular",
}

-- Root markers for ESLint config detection. Needed to find project root reliably.
local root_markers = {
	".eslintrc",
	".eslintrc.js",
	".eslintrc.json",
	"eslint.config.js",
	".git", -- git root often good fallback
}

--- Detects the root directory for ESLint LSP.
--- Combines project config files with package manager lockfiles for monorepo detection.
--- Uses asynchronous on_dir callback per native LSP API expectations.
local function root_dir(bufnr, on_dir)
	local filepath = vim.api.nvim_buf_get_name(bufnr)

	if not filepath or filepath == "" then
		local cwd = vim.loop.cwd()
		on_dir(cwd)
		return
	end

	local lockfiles = {
		"package-lock.json",
		"yarn.lock",
		"pnpm-lock.yaml",
		"bun.lockb",
		"bun.lock",
	}
	local root = utils.find_root(filepath, root_markers) or utils.find_root(filepath, lockfiles)

	on_dir(root or vim.loop.cwd())
end

--- Specific handlers for ESLint LSP server messages.
local eslint_handlers = {
	["eslint/openDoc"] = function(_, result)
		if result then
			vim.ui.open(result.url)
		end
		return {}
	end,
	["eslint/confirmESLintExecution"] = function(_, result)
		if not result then
			return
		end
		return 4 -- Approve ESLint execution automatically.
	end,
	["eslint/probeFailed"] = function()
		vim.notify("[lspconfig] ESLint probe failed.", vim.log.levels.WARN)
		return {}
	end,
	["eslint/noLibrary"] = function()
		vim.notify("[lspconfig] Unable to find ESLint library.", vim.log.levels.WARN)
		return {}
	end,
}

--- Called when the ESLint LSP attaches to buffer.
--- Disables diagnostics for unnamed buffers to avoid noise.
local function on_attach(client, bufnr)
	if handlers.on_attach then
		handlers.on_attach(client, bufnr)
	end

	local fname = vim.api.nvim_buf_get_name(bufnr)
	if not fname or fname == "" then
		client.handlers["textDocument/publishDiagnostics"] = function(_, _, _)
			-- Suppress diagnostics for unnamed buffers.
		end
	end
end

--- Pre-initialization setup before the ESLint LSP launches.
--- Configures the workspace folder, detects flat config presence for experimental support,
--- and patches command for Yarn Plug'n'Play projects.
local function before_init(_, config)
	local root = config.root_dir
	if root then
		config.settings = config.settings or {}
		config.settings.workspaceFolder = {
			uri = root,
			name = vim.fn.fnamemodify(root, ":t"),
		}

		local flat_config_files = {}
		for _, file in ipairs(root_markers) do
			if file:match("config") then
				table.insert(flat_config_files, file)
			end
		end

		for _, file in ipairs(flat_config_files) do
			local found_files = vim.fn.globpath(root, file, true, true)
			local filtered_files = {}
			for _, f in ipairs(found_files) do
				if not f:match("[/\\]node_modules[/\\]") then
					table.insert(filtered_files, f)
				end
			end
			if #filtered_files > 0 then
				config.settings.experimental = config.settings.experimental or {}
				config.settings.experimental.useFlatConfig = true
				break
			end
		end

		local pnp_cjs = root .. "/.pnp.cjs"
		local pnp_js = root .. "/.pnp.js"
		if vim.uv.fs_stat(pnp_cjs) or vim.uv.fs_stat(pnp_js) then
			config.cmd = vim.list_extend({ "yarn", "exec" }, config.cmd)
		end
	end
end

--- Settings table for ESLint LSP server configuration.
--- Controls validation, formatting, code actions, experimental features, and related preferences.
local settings = {
	workingDirectory = { mode = "auto" },
	validate = "on",
	format = true,
	run = "onType",
	experimental = {
		useFlatConfig = false,
	},
	codeActionOnSave = {
		enable = false,
		mode = "all",
	},
	quiet = false,
	onIgnoredFiles = "off",
	rulesCustomizations = {},
	problems = {
		shortenToSingleLine = false,
	},
	codeAction = {
		disableRuleComment = {
			enable = true,
			location = "separateLine",
		},
		showDocumentation = {
			enable = true,
		},
	},
	nodePath = "",
}

local cmd = { "vscode-eslint-language-server", "--stdio" }

return {
	on_attach = on_attach,
	capabilities = handlers.capabilities,
	cmd = cmd,
	filetypes = filetypes,
	root_markers = root_markers,
	root_dir = root_dir,
	workspace_required = true,
	settings = settings,
	before_init = before_init,
	handlers = eslint_handlers,
}
