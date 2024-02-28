-- General --

-- Disables automatic commenting on newline and sets some general format options.
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  callback = function()
    vim.opt.formatoptions = "cjoqt"
  end,
})

-- Remove trailing whitespace.
vim.cmd([[
  fun! TrimTrailingWhitespace()
    if !&binary && &filetype != 'diff'
      let l:save = winsaveview()
      keeppatterns %s/\s\+$//e
      call winrestview(l:save)
    endif
  endfun

  augroup vimrc
    au!
    autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
    \ |   exe "normal! g`\""
    \ | endif
    autocmd BufWritePre * :call TrimTrailingWhitespace()
  augroup END
]])

-- Set up skeletons.
vim.cmd([[
  augroup skeletons
    au!
    autocmd BufNewFile *.* silent! execute '0r ~/.config/nvim/templates/skeleton.'.expand("<afile>:e")
  augroup END
]])

-- Filetypes --

-- Markdown
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
    vim.opt_local.spelllang = { "de_de", "en_us" }
  end,
})

-- Git commit
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "gitcommit" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
    vim.opt_local.spelllang = { "de_de", "en_us" }
  end,
})

-- Python
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "python" },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.smarttab = true
    vim.opt_local.expandtab = true
    vim.opt_local.autoindent = true
    vim.opt_local.smartindent = true
    -- vim.opt_local.textwidth = 79
    vim.opt_local.colorcolumn = "80"
  end,
})

-- Run code --
-- Python
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "python" },
  callback = function()
    vim.cmd([[
      nnoremap <buffer> <leader>e :sp<CR> :term python %<CR> :startinsert<CR>
    ]])
  end,
})
-- JS
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "javascript" },
  callback = function()
    vim.cmd([[
      nnoremap <buffer> <leader>e :sp<CR> :term node %<CR> :startinsert<CR>
    ]])
  end,
})
-- Java
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "java" },
  callback = function()
    vim.cmd([[
      nnoremap <buffer> <leader>e :sp<CR> :term java %<CR> :startinsert<CR>
    ]])
  end,
})
