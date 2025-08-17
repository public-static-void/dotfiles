local utils = require("user.utils")

local handlers = utils.safe_require("user.lsp.handlers")
if not handlers then
	return
end

local jdtls = utils.safe_require("jdtls")
if not jdtls then
	return
end

local on_attach = function(client, bufnr)
	if client.name == "jdtls" then
		-- Setup the DAP integration managed by nvim-jdtls
		jdtls.setup_dap()
	end
	handlers.on_attach(client, bufnr)
end

local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
local root_dir = jdtls.setup.find_root(root_markers)
if root_dir == "" then
	print("No Project root found!")
	return
end

local home = os.getenv("HOME")
local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
local workspace_dir = home .. "/workspace/" .. project_name
local mason_path = vim.fn.stdpath("data") .. "/mason/packages"

local bundles = utils.find_bundles({
	mason_path .. "/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar",
	mason_path .. "/java-test/extension/server/com.microsoft.java.test.plugin-*.jar",
})

local launcher_jar = vim.fn.glob(mason_path .. "/jdtls/plugins/org.eclipse.equinox.launcher_*.jar")

local config_dir = mason_path
	.. "/jdtls/config_"
	.. (vim.fn.has("win32") == 1 and "win" or (vim.fn.has("macunix") == 1 and "mac" or "linux"))

return {
	on_attach = on_attach,
	capabilities = handlers.capabilities,
	cmd = {
		"java",
		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=true",
		"-Dlog.level=ALL",
		"-Xmx1g",
		"--add-modules=ALL-SYSTEM",
		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",
		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",
		"-jar",
		launcher_jar,
		"-configuration",
		config_dir,
		"-data",
		workspace_dir,
	},
	root_markers = root_markers,
	root_dir = root_dir,
	filetypes = { "java" },
	settings = {
		java = {
			eclipse = { downloadSources = true },
			configuration = { updateBuildConfiguration = "interactive" },
			maven = { downloadSources = true },
			implementationsCodeLens = { enabled = true },
			referencesCodeLens = { enabled = true },
			references = { includeDecompiledSources = true },
			format = { enabled = false },
		},
		signatureHelp = { enabled = true },
		completion = {
			favoriteStaticMembers = {
				"org.hamcrest.MatcherAssert.assertThat",
				"org.hamcrest.Matchers.*",
				"org.hamcrest.CoreMatchers.*",
				"org.junit.jupiter.api.Assertions.*",
				"java.util.Objects.requireNonNull",
				"java.util.Objects.requireNonNullElse",
				"org.mockito.Mockito.*",
			},
		},
		contentProvider = { preferred = "fernflower" },
		extendedClientCapabilities = jdtls.extendedClientCapabilities,
		sources = {
			organizeImports = {
				starThreshold = 9999,
				staticStarThreshold = 9999,
			},
		},
		codeGeneration = {
			toString = {
				template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
			},
			useBlocks = true,
		},
	},
	flags = {
		allow_incremental_sync = true,
	},
	init_options = {
		bundles = bundles,
	},
}
