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

local status_ok, lazy = pcall(require, "lazy")
if not status_ok then
  return
end

-- Install plugins
return lazy.setup({
  {
    -- An implementation of the Popup API from vim in Neovim
    "nvim-lua/popup.nvim",
    lazy = true,
  },
  {
    -- Useful lua functions used by lots of plugins
    "nvim-lua/plenary.nvim",
    lazy = true,
  },
  {
    -- Autopairs, integrates with both cmp and treesitter
    "windwp/nvim-autopairs",
    lazy = true,
  },
  {
    -- Easily comment stuff
    "numToStr/Comment.nvim",
    lazy = true,
  },
  {
    "kyazdani42/nvim-web-devicons",
    lazy = true,
  },
  {
    "kyazdani42/nvim-tree.lua",
    lazy = true,
  },
  {
    "akinsho/bufferline.nvim",
    lazy = true,
  },
  {
    "moll/vim-bbye",
    lazy = false,
  },
  {
    "nvim-lualine/lualine.nvim",
    lazy = true,
  },
  {
    "akinsho/toggleterm.nvim",
    lazy = true,
  },
  {
    "ahmedkhalf/project.nvim",
    lazy = true,
  },
  {
    "lewis6991/impatient.nvim",
    lazy = true,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    lazy = true,
  },
  {
    "goolord/alpha-nvim",
    lazy = true,
  },
  {
    -- This is needed to fix lsp doc highlight
    "antoinemadec/FixCursorHold.nvim",
    lazy = false,
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
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = true,
  },
  {
    -- for formatters and linters
    "jose-elias-alvarez/null-ls.nvim",
    lazy = true,
  },
  {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "jose-elias-alvarez/null-ls.nvim",
    },
  },
  {
    "mfussenegger/nvim-jdtls",
    lazy = true,
  },

  -- snippets
  {
    -- snippet engine
    "L3MON4D3/LuaSnip",
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
    event = "InsertEnter",
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
    },
  },

  -- debugger
  {
    "mfussenegger/nvim-dap",
    lazy = true,
  },
  {
    "rcarriga/nvim-dap-ui",
    lazy = true,
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
    -- build = "npm i && npm run compile vsDebugServerBundle && mv dist out",
    build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    lazy = true,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdateSync",
    event = "BufReadPost",
    lazy = true,
  },
  -- {
  --   "p00f/nvim-ts-rainbow",
  --   lazy = true,
  -- },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    lazy = false,
  },
  {
    "windwp/nvim-ts-autotag",
    lazy = false,
  },
  {
    "HiPhish/rainbow-delimiters.nvim",
    lazy = false,
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
    "NvChad/nvim-colorizer.lua",
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

  -- {
  -- 	"AlphaTechnolog/pywal.nvim",
  -- 	name = "pywal",
  -- },
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
    lazy = true,
  },
  -- {
  -- 	"sunjon/shade.nvim",
  -- 	config = function()
  -- 		require("shade").setup({
  -- 			overlay_opacity = 75,
  -- 			opacity_step = 5,
  -- 		})
  -- 	end,
  --    lazy = true,
  -- },
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
})
