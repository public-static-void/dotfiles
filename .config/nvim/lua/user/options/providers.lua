--- Provider executable detection and configuration.
--- Dynamically detects Python3, Perl, and Node providers and sets Neovim globals accordingly.

local vim_g = vim.g
local fn = vim.fn

local python3 = fn.exepath("python3")
if python3 == "" then
	python3 = fn.exepath("python")
end
if python3 ~= "" then
	vim_g.python3_host_prog = python3
end

local perl = fn.exepath("perl")
if perl ~= "" then
	vim_g.perl_host_prog = perl
end

local node = fn.exepath("neovim-node-host")
if node ~= "" then
	vim_g.node_host_prog = node
end
