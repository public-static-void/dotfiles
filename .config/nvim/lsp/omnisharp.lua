local utils = require("user.utils")

local handlers = utils.safe_require("user.configs.lsp.handlers")
if not handlers then
	return
end

local filetypes = {
	"cs",
	"vb",
}

local root_markers = { "*.sln", "*.csproj", "omnisharp.json", "function.json" }

--- Locate the root directory for the given buffer by searching for project markers.
--- Falls back to the current working directory if none found.
---@param bufnr number Buffer number to find root for
---@param on_dir fun(path: string) Callback invoked with root directory path
local function root_dir(bufnr, on_dir)
	local filepath = vim.api.nvim_buf_get_name(bufnr)
	if not filepath or filepath == "" then
		on_dir(vim.loop.cwd())
		return
	end
	local root = utils.find_root(filepath, root_markers)
	on_dir(root or vim.loop.cwd())
end

local settings = {
	FormattingOptions = {
		-- Enable support for reading code style, naming convention, and analyzer settings from .editorconfig
		EnableEditorConfigSupport = true,
		-- Specifies whether 'using' directives should be grouped and sorted in formatting
		OrganizeImports = nil,
	},
	MsBuild = {
		-- If true, only load projects corresponding to opened files for faster navigation setup
		LoadProjectsOnDemand = nil,
	},
	RoslynExtensionsOptions = {
		-- Enables support for roslyn analyzers, code fixes, and rulesets
		EnableAnalyzersSupport = nil,
		-- Enables showing unimported types and extension methods with auto adding of directives
		EnableImportCompletion = nil,
		-- Only run analyzers against open documents
		AnalyzeOpenDocumentsOnly = nil,
	},
	Sdk = {
		-- Include preview SDK versions when selecting project SDK
		IncludePrereleases = true,
	},
}

--- Function to modify new server config before starting OmniSharp
---@param new_config table The new lspconfig config table
---@param _ table Ignored second argument
local function on_new_config(new_config, _)
	new_config.cmd = { unpack(new_config.cmd or {}) }
	table.insert(new_config.cmd, "-z")
	vim.list_extend(new_config.cmd, { "--hostPID", tostring(vim.fn.getpid()) })
	table.insert(new_config.cmd, "DotNet:enablePackageRestore=false")
	vim.list_extend(new_config.cmd, { "--encoding", "utf-8" })
	table.insert(new_config.cmd, "--languageserver")

	local function flatten(tbl)
		local ret = {}
		for k, v in pairs(tbl) do
			if type(v) == "table" then
				for _, pair in ipairs(flatten(v)) do
					ret[#ret + 1] = k .. ":" .. pair
				end
			else
				ret[#ret + 1] = k .. "=" .. vim.inspect(v)
			end
		end
		return ret
	end

	if new_config.settings then
		vim.list_extend(new_config.cmd, flatten(new_config.settings))
	end

	new_config.capabilities = vim.deepcopy(new_config.capabilities)
	if new_config.capabilities.workspace then
		new_config.capabilities.workspace.workspaceFolders = false
	end
end

local cmd = { "OmniSharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) }

return {
	cmd = cmd,
	filetypes = filetypes,
	root_dir = root_dir,
	on_attach = handlers.on_attach,
	on_new_config = on_new_config,
	capabilities = handlers.capabilities,
	settings = settings,
}
