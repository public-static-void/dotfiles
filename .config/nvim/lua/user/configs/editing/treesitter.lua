local utils = require("user.utils")

local treesitter = utils.safe_require("nvim-treesitter")
if not treesitter then
	return
end

treesitter.setup({
	install_dir = vim.fn.stdpath("data") .. "/site",
})

local ensureInstalled = {
	"angular",
	"bash",
	"bibtex",
	"blade",
	"c",
	"c_sharp",
	"clojure",
	"cmake",
	"commonlisp",
	"cpp",
	"css",
	"csv",
	"cuda",
	"dart",
	"diff",
	"dockerfile",
	"editorconfig",
	"elixir",
	"elm",
	"erlang",
	"fennel",
	"fish",
	"fortran",
	"fsharp",
	"git_config",
	"git_rebase",
	"gitattributes",
	"gitcommit",
	"gitignore",
	"gnuplot",
	"go",
	"gpg",
	"graphql",
	"groovy",
	"haskell",
	"helm",
	"html",
	"htmldjango",
	"http",
	"ini",
	"java",
	"javadoc",
	"javascript",
	"jinja",
	"jinja_inline",
	"jq",
	"jsdoc",
	"json",
	"jsx",
	"julia",
	"kotlin",
	"latex",
	"llvm",
	"lua",
	"luadoc",
	"make",
	"markdown",
	"markdown_inline",
	"matlab",
	"mermaid",
	"nginx",
	"objc",
	"ocaml",
	"pascal",
	"perl",
	"php",
	"phpdoc",
	"powershell",
	"prisma",
	"python",
	"r",
	"racket",
	"regex",
	"requirements",
	"ruby",
	"rust",
	"scheme",
	"scss",
	"sql",
	"ssh_config",
	"svelte",
	"swift",
	"terraform",
	"toml",
	"tsx",
	"twig",
	"typescript",
	"vhdl",
	"vim",
	"vimdoc",
	"vue",
	"xml",
	"xresources",
	"yaml",
	"zig",
	"zsh",
}

treesitter.install(ensureInstalled)

-- Enable treesitter highlighting per buffer
vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function(args)
		local buf = args.buf
		if vim.bo[buf].buftype ~= "" then
			return
		end
		pcall(vim.treesitter.start, buf)
	end,
})

-- Enable treesitter‑based indentation per buffer
vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function(args)
		local buf = args.buf
		if vim.bo[buf].buftype ~= "" then
			return
		end
		vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})
