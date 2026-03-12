--- LTeX LS language server configuration for Neovim LSP client.
--- Provides spellchecking, grammar checking, and dictionary completion.
--- Configured for LaTeX, Markdown, and other supported text filetypes.
local utils = require("user.utils")

local handlers = utils.safe_require("user.configs.lsp.handlers")
if not handlers then
	return
end

--- List of supported filetypes for LTeX LS.
local filetypes = {
	"bib",
	"gitcommit",
	"mail",
	"markdown",
	"org",
	"pandoc",
	"plaintex",
	"quarto",
	"rmd",
	"rnoweb",
	"rst",
	"tex",
	"text",
}

--- Root markers used to identify project root.
local root_markers = { ".git" }

--- Maps Neovim filetypes to corresponding LTeX language IDs.
local language_id_mapping = {
	bib = "bibtex",
	plaintex = "tex",
	rnoweb = "rsweave",
	rst = "restructuredtext",
	tex = "latex",
	pandoc = "markdown",
	text = "plaintext",
}

--- Maps a Neovim filetype to the corresponding LTeX language ID.
--- Falls back to the original filetype if there is no mapping.
--- @param _ table Unused first parameter for API compatibility.
--- @param filetype string Neovim buffer filetype.
--- @return string Language ID for LTeX or original filetype.
local function get_language_id(_, filetype)
	return language_id_mapping[filetype] or filetype
end

--- Builds a deduplicated list of enabled language IDs from filetypes.
local enabled_ids = {}
do
	local seen = {}
	for _, ft in ipairs(filetypes) do
		local lang_id = get_language_id({}, ft)
		if not seen[lang_id] then
			seen[lang_id] = true
			table.insert(enabled_ids, lang_id)
		end
	end
end

local uv = vim.loop
local mason_base = vim.fn.stdpath("data") .. "/mason/packages/ltex-ls-plus"

--- Retrieves the latest installed version of ltex-ls from Mason packages.
--- @return string|nil Version folder name or nil if none found.
local function get_latest_version()
	local versions = {}
	local iter = uv.fs_scandir(mason_base)
	if not iter then
		return nil
	end
	while true do
		local name = uv.fs_scandir_next(iter)
		if not name then
			break
		end
		if name:match("^ltex%-ls%-plus%-%d") then
			table.insert(versions, name)
		end
	end
	if #versions == 0 then
		return nil
	end
	table.sort(versions)
	return versions[#versions]
end

local version = get_latest_version()
if not version then
	error("ltex-ls-plus not installed via Mason.")
end

local version_path = mason_base .. "/" .. version

--- Builds Java classpath string from all jars in the lib directory.
--- @param jar_dir string Directory containing jar files.
--- @return string Classpath string separated by ':'.
local jars_classpath = utils.build_classpath(version_path .. "/lib")

--- Asynchronous root directory detection for Neovim native LSP API.
--- @param bufnr number Buffer number.
--- @param on_dir function Callback invoked with root directory.
local root_dir = function(bufnr, on_dir)
	local fname = vim.api.nvim_buf_get_name(bufnr)
	if not fname or fname == "" then
		on_dir(vim.loop.cwd())
		return
	end
	local root = utils.find_root(fname, root_markers)
	on_dir(root or vim.loop.cwd())
end

--- Uses Neovim's native 'spelllang' option to set LTeX language dynamically.
--- Converts common spelllang codes to LTeX style language tags.
--- @param bufnr number Buffer number.
--- @return string[] List of language codes for LTeX.
local function detect_languages_from_spelllang(bufnr)
	local langs = vim.opt.spelllang:get()
	if not langs or #langs == 0 then
		return { "en-US" }
	end
	local map = {
		en = "en-US",
		de = "de-DE",
		fr = "fr",
		es = "es",
		it = "it",
	}
	local detected = {}
	for _, lang in ipairs(langs) do
		table.insert(detected, map[lang] or lang)
	end
	return detected
end

--- Updates LTeX client language settings from spelllang.
--- @param client table LSP client object.
--- @param bufnr number Buffer number.
local function update_ltex_language(client, bufnr)
	local langs = detect_languages_from_spelllang(bufnr)
	client.config.settings = client.config.settings or {}
	client.config.settings.ltex = client.config.settings.ltex or {}
	-- LTeX expects a single string for language; use the first detected language only
	client.config.settings.ltex.language = langs[1] or "en-US"
	client:notify("workspace/didChangeConfiguration", { settings = client.config.settings })
end

--- LSP attach handler executes user-defined attach routine if defined.
--- Sets ltex language dynamically based on Neovim's spelllang.
--- Also attaches an autocmd on `OptionSet` for `spelllang` to update language dynamically.
--- @param client table LSP client object.
--- @param bufnr number Buffer number.
local function on_attach(client, bufnr)
	if client.name == "ltex-ls-plus" then
		update_ltex_language(client, bufnr)
		local group_id = vim.api.nvim_create_augroup("LtexPlusSpelllangUpdate", { clear = true })
		vim.api.nvim_create_autocmd("OptionSet", {
			group = group_id,
			pattern = "spelllang",
			callback = function()
				local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
				for _, c in ipairs(clients) do
					if c.name == "ltex-ls-plus" then
						update_ltex_language(c, bufnr)
					end
				end
			end,
		})
	end
	if handlers.on_attach then
		handlers.on_attach(client, bufnr)
	end
end

local settings = {
	ltex = {
		language = "en-US",
		enabled = enabled_ids,
		completionEnabled = true,
		diagnosticSeverity = "information",
		sentenceCacheSize = 2000,
		additionalRules = {
			enablePickyRules = false,
		},
	},
}

local cmd = {
	"java",
	"-Djdk.xml.totalEntitySizeLimit=1000000",
	"-cp",
	jars_classpath,
	"org.bsplines.ltexls.LtexLanguageServerLauncher",
}

return {
	on_attach = on_attach,
	capabilities = handlers.capabilities,
	cmd = cmd,
	filetypes = filetypes,
	root_markers = root_markers,
	root_dir = root_dir,
	settings = settings,
	get_language_id = get_language_id,
}
