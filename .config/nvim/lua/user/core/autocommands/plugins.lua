--- Plugin Lifecycle Autocommands
--- Centralized hooks for post-install/update actions required by vim.pack.

local augroup = vim.api.nvim_create_augroup("VimPack", { clear = true })

--- Update tree-sitter parsers.
--- Runs TSUpdate only when nvim-treesitter is updated.
--- @param ev table The event data provided by PackChanged.
vim.api.nvim_create_autocmd("PackChanged", {
	group = augroup,
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if name == "nvim-treesitter" and kind == "update" then
			if not ev.data.active then
				vim.cmd.packadd("nvim-treesitter")
			end
			vim.cmd("TSUpdate")
		end
	end,
})

--- Update mason and its toolchain.
--- Runs MasonUpdate when the plugin is updated.
--- @param ev table The event data provided by PackChanged.
vim.api.nvim_create_autocmd("PackChanged", {
	group = augroup,
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if name == "mason.nvim" and kind == "update" then
			if not ev.data.active then
				vim.cmd.packadd("mason.nvim")
			end
			vim.cmd("MasonUpdate")
		end
	end,
})

--- Rebuild blink.cmp native code.
--- Triggers cargo build when the plugin is updated.
--- @param ev table The event data provided by PackChanged.
vim.api.nvim_create_autocmd("PackChanged", {
	group = augroup,
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if name == "blink.cmp" and kind == "update" then
			if not ev.data.active then
				vim.cmd.packadd("blink.cmp")
			end
			vim.fn.jobstart({ "cargo", "build", "--release" }, { cwd = ev.data.path })
		end
	end,
})

--- Rebuild markdown-preview.nvim dependencies.
--- Runs yarn install when the plugin is updated.
--- @param ev table The event data provided by PackChanged.
vim.api.nvim_create_autocmd("PackChanged", {
	group = augroup,
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if name == "markdown-preview.nvim" and kind == "update" then
			if not ev.data.active then
				vim.cmd.packadd("markdown-preview.nvim")
			end
			vim.fn.jobstart({ "sh", "-c", "cd app && yarn install" }, { cwd = ev.data.path })
		end
	end,
})

--- Start markdown-preview.nvim automatically for Markdown buffers.
--- Configures the preview to open when entering a markdown file.
vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = "markdown",
	callback = function()
		vim.g.mkdp_filetypes = { "markdown" }
		vim.g.mkdp_auto_start = 0
		vim.g.mkdp_theme = "light"
	end,
})

return {}
