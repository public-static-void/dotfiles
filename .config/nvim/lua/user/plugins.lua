local utils = require("user.utils")

-- Automatically install lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local lazy = utils.safe_require("lazy")
if not lazy then
	return
end

-- -- Auto update on startup
-- vim.api.nvim_create_autocmd("User", {
--   pattern = "LazyVimStarted",
--   callback = function()
--     lazy.sync({ wait = false, show = true })
--   end,
-- })

-- Install plugins
return lazy.setup({
	{
		-- An implementation of the Popup API from vim in Neovim
		"nvim-lua/popup.nvim",
		lazy = true,
	},
	{
		-- Autopairs, integrates with both cmp and treesitter
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
	},
	{
		"nvim-tree/nvim-tree.lua",
		cmd = "NvimTreeToggle",
		lazy = true,
	},
	{ "akinsho/bufferline.nvim", version = "*", dependencies = "nvim-tree/nvim-web-devicons" },
	{
		"nvim-lualine/lualine.nvim",
		event = "VimEnter",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	{
		"moll/vim-bbye",
	},
	{ "akinsho/toggleterm.nvim", version = "*", config = true },
	{
		"ahmedkhalf/project.nvim",
		lazy = true,
	},
	{
		"stevearc/aerial.nvim",
		opts = {},
		-- Optional dependencies
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
	},
	{ "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {}, lazy = true },
	{
		"goolord/alpha-nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},

	-- Colorschemes
	{
		"lunarvim/colorschemes",
		lazy = true,
	},
	{
		"lunarvim/darkplus.nvim",
		lazy = true,
	},
	{
		"zacanger/angr.vim",
		lazy = true,
	},
	{
		"tomasiser/vim-code-dark",
		lazy = true,
	},
	{
		"srcery-colors/srcery-vim",
		lazy = true,
	},
	{
		"mhinz/vim-janah",
		lazy = true,
	},
	{
		"Mofiqul/vscode.nvim",
		lazy = true,
	},
	{
		"RRethy/nvim-base16",
		lazy = true,
	},

	-- LSP
	{
		-- enable LSP
		"neovim/nvim-lspconfig",
		lazy = true,
	},
	{
		"williamboman/mason.nvim",
		lazy = true,
		build = ":MasonUpdate",
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = true,
	},
	{
		"jay-babu/mason-null-ls.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"nvimtools/none-ls.nvim",
		},
	},
	{
		"mfussenegger/nvim-jdtls",
		lazy = true,
	},
	-- java lsp
	{
		"nvim-java/nvim-java",
		dependencies = {
			"nvim-java/lua-async-await",
			"nvim-java/nvim-java-refactor",
			"nvim-java/nvim-java-core",
			"nvim-java/nvim-java-test",
			"nvim-java/nvim-java-dap",
			"MunifTanjim/nui.nvim",
			"neovim/nvim-lspconfig",
			"mfussenegger/nvim-dap",
			{
				"williamboman/mason.nvim",
				opts = {
					registries = {
						"github:nvim-java/mason-registry",
						"github:mason-org/mason-registry",
					},
				},
			},
		},
	},
	-- Rust
	{
		"mrcjkb/rustaceanvim",
		version = "^4", -- Recommended
		lazy = false, -- This plugin is already lazy
	},

	-- snippets
	{
		-- snippet engine
		"L3MON4D3/LuaSnip",
		-- follow latest release.
		version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
		-- install jsregexp (optional!).
		build = "make install_jsregexp",
		lazy = true,
		dependencies = {
			-- a bunch of snippets to use
			"rafamadriz/friendly-snippets",
		},
	},

	-- completion
	{
		-- The completion plugin
		"hrsh7th/nvim-cmp",
		lazy = true,
		event = { "InsertEnter", "CmdlineEnter" },
		dependencies = {
			-- buffer completions
			"hrsh7th/cmp-buffer",
			-- path completions
			"hrsh7th/cmp-path",
			-- cmdline completions
			"hrsh7th/cmp-cmdline",
			-- snippet completions
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lua",
			"f3fora/cmp-spell",
			-- nvim-cmp source for nvim-dap REPL and nvim-dap-ui buffers
			"rcarriga/cmp-dap",
			-- llm cmp
			"tzachar/cmp-ai",
		},
	},
	-- Copilot
	{
		-- "aliaksandr-trush/codeium.nvim",
		-- branch = "update_server_version",
		"Exafunction/codeium.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"hrsh7th/nvim-cmp",
		},
		config = function()
			require("codeium").setup({
				enable_chat = true,
			})
		end,
	},
	{
		"David-Kunz/gen.nvim",
		lazy = false,
	},
	{
		"tzachar/cmp-ai",
		dependencies = "nvim-lua/plenary.nvim",
		lazy = false,
	},

	-- debugger
	{
		"mfussenegger/nvim-dap",
		cmd = { "DapContinue", "DapToggleBreakpoint" },
		lazy = true,
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
	},
	{
		"ravenxrz/DAPInstall.nvim",
		lazy = true,
	},
	{
		"jay-babu/mason-nvim-dap.nvim",
		lazy = true,
	},
	{
		"mxsdev/nvim-dap-vscode-js",
		lazy = true,
	},
	{
		"microsoft/vscode-js-debug",
		version = "1.x",
		build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out && git restore .",
	},
	{
		"leoluz/nvim-dap-go",
		lazy = true,
	},
	{
		"mfussenegger/nvim-dap-python",
		lazy = true,
	},

	-- Telescope
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.6",
		dependencies = { "nvim-lua/plenary.nvim" },
	},

	-- Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		-- build = ":TSUpdateSync",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		lazy = true,
	},
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
	},
	{
		"windwp/nvim-ts-autotag",
		lazy = false,
	},
	{
		"HiPhish/rainbow-delimiters.nvim",
		dependencies = "nvim-treesitter/nvim-treesitter",
		event = { "BufReadPost", "BufNewFile", "BufWritePre", "VeryLazy" },
		lazy = true,
	},
	{
		"jwalton512/vim-blade",
		ft = { "blade" },
		lazy = true,
	},

	-- Git
	{
		"lewis6991/gitsigns.nvim",
		lazy = true,
	},

	-- Additional plugins
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
			vim.g.mkdp_auto_start = 1
			vim.g.mkdp_theme = "light"
		end,
		lazy = true,
	},
	{
		"brenoprata10/nvim-highlight-colors",
		lazy = true,
	},
	{
		"RRethy/vim-illuminate",
		lazy = true,
	},
	{
		"danymat/neogen",
		lazy = true,
	},

	{
		"AlphaTechnolog/pywal.nvim",
		name = "pywal",
	},
	{
		"cameron-wags/rainbow_csv.nvim",
		config = function()
			require("rainbow_csv").setup()
		end,
		-- optional lazy-loading below
		module = {
			"rainbow_csv",
			"rainbow_csv.fns",
		},
		ft = {
			"csv",
			"tsv",
			"csv_semicolon",
			"csv_whitespace",
			"csv_pipe",
			"rfc_csv",
			"rfc_semicolon",
		},
		lazy = true,
	},
	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
			})
		end,
	},
	{
		"miversen33/sunglasses.nvim",
		event = "UIEnter",
		config = function()
			require("sunglasses").setup({
				filter_percent = 0.25,
			})
		end,
		lazy = true,
	},
	{
		"famiu/bufdelete.nvim",
		lazy = true,
	},
})
