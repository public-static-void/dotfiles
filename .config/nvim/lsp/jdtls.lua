local utils = require("user.utils")

local handlers = utils.safe_require("user.configs.lsp.handlers")
if not handlers then
	return
end

local jdtls = utils.safe_require("jdtls")
if not jdtls then
	return
end

local jdtls_dap = utils.safe_require("jdtls.dap")
if not jdtls_dap then
	return
end

local filetypes = { "java" }

--- Markers to find project root for java
local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }

--- Root directory detection using jdtls built-in functionality
local root_dir = jdtls.setup.find_root(root_markers)
if root_dir == "" then
	print("No Project root found!")
	return
end

--- Base directories used for workspace and mason packages
local home = os.getenv("HOME") or os.getenv("USERPROFILE") or vim.fn.expand("~")
local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
local workspace_dir = home .. "/workspace/" .. project_name
local mason_path = vim.fn.stdpath("data") .. "/mason/packages"
vim.fn.mkdir(workspace_dir, "p")

--- Search for debug and test bundles installed by mason
local bundles = {}

-- Get java-debug jars
local java_debug_jars = vim.split(vim.fn.glob(mason_path .. "/java-debug-adapter/extension/server/*.jar", 1), "\n")
vim.list_extend(bundles, java_debug_jars)

-- Get java-test jars
local java_test_jars = vim.split(vim.fn.glob(mason_path .. "/java-test/extension/server/*.jar", 1), "\n")

local exclude = {
	"com.microsoft.java.test.runner-jar-with-dependencies.jar",
	"jacocoagent.jar",
}

for _, jar_path in ipairs(java_test_jars) do
	local jar_name = vim.fn.fnamemodify(jar_path, ":t")
	if not vim.tbl_contains(exclude, jar_name) then
		table.insert(bundles, jar_path)
	end
end

--- Launcher jar and config dir adjusted per platform
local launcher_jar = vim.fn.glob(mason_path .. "/jdtls/plugins/org.eclipse.equinox.launcher_*.jar")
local lombok_jar = vim.fn.glob(mason_path .. "/jdtls/lombok.jar")
local config_dir = mason_path
	.. "/jdtls/config_"
	.. (vim.fn.has("win32") == 1 and "win" or (vim.fn.has("macunix") == 1 and "mac" or "linux"))

--- Custom on_attach to setup nvim-jdtls dap integration for Java debugging
local function on_attach(client, bufnr)
	if client.name == "jdtls" then
		jdtls.setup_dap({ hotcodereplace = "auto" })
		jdtls_dap.setup_dap_main_class_configs()
	end
	-- refresh codelens after attaching
	vim.lsp.codelens.refresh()
	-- auto refresh codelens on each save of a Java file
	vim.api.nvim_create_autocmd("BufWritePost", {
		buffer = bufnr,
		callback = function()
			local ok, _ = pcall(vim.lsp.codelens.refresh)
			if not ok then
				print("[jdtls] codelens refresh failed")
			end
		end,
	})
end

local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

--- Settings for jdtls with code lens, completion, formatting, and debug options
local settings = {
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
		-- Try not to suggest imports from these packages in the code action window
		filteredTypes = {
			"com.sun.*",
			"io.micrometer.shaded.*",
			"java.awt.*",
			"jdk.*",
			"sun.*",
		},
		-- Set the order in which the language server should organize imports
		importOrder = {
			"java",
			"jakarta",
			"javax",
			"com",
			"org",
		},
	},
	contentProvider = { preferred = "fernflower" },
	extendedClientCapabilities = extendedClientCapabilities,
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
		hashCodeEquals = {
			useJava7Objects = true,
		},
		useBlocks = true,
	},
}

local init_options = {
	bundles = bundles,
	extendedClientCapabilities = extendedClientCapabilities,
}

--- Command to launch jdtls language server with necessary JVM options and paths
local cmd = {
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
	"-javaagent:" .. lombok_jar,
	"-jar",
	launcher_jar,
	"-configuration",
	config_dir,
	"-data",
	workspace_dir,
}

local config = {
	cmd = cmd,
	filetypes = filetypes,
	root_markers = root_markers,
	root_dir = root_dir,
	on_attach = on_attach,
	capabilities = handlers.capabilities,
	settings = settings,
	flags = {
		allow_incremental_sync = true,
	},
	init_options = init_options,
}

return config
