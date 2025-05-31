""""""""""""
" ~/.vimrc "
""""""""""""

"""""""""""
" PLUGINS "
"""""""""""

" Turn off filetype detection for a second. Will be turned back on later on.
filetype off

" Enable comment toggling
if exists(':packadd')
  silent! packadd comment
endif

""""""""""""""""""""
" GENERAL SETTINGS "
""""""""""""""""""""

" Disable beeps.
set noerrorbells
set visualbell
set t_vb=

" Set encoding to UTF-8.
set encoding=utf-8
set fileencodings=utf-8
scriptencoding utf-8

" Enables 24-bit RGB colors. Uses 'gui' attributes instead of 'cterm' attributes. Requires an ISO-8613-3 compatible terminal.
if has('termguicolors')
  set termguicolors
endif

" Set shell.
if exists('$SHELL')
  set shell=$SHELL
else
  set shell=/bin/sh
endif

" Leader key variable.
let mapleader = ' '

" Allow plugins to determine indentation.
filetype plugin indent on

" Fix backspace indent
set backspace=indent,eol,start

" Change vim's updatetime option; the default value is 4000, i.e. 4 seconds.
set updatetime=100

" Automatically set current directory to file's location.
set autochdir

" Watch for file changes.
set autoread

" Enable system clipboard for copy/paste from/to outside vim.
if has('unnamedplus')
  set clipboard=unnamed,unnamedplus
endif

" Enable syntax highlighting.
syntax on

" Show the file name in the terminal title bar.
set title

" Enable line numbers.
set number
set relativenumber

" Show row and column information.
set ruler

" Always show tabs-bar.
set showtabline=2

" Disable modelines as a security precaution
set modelines=0
set nomodeline

" Prevent non-normal modes showing in statusline and below statusline.
set noshowmode

" Colors.
" colorscheme koehler
" colorscheme sorbet
" colorscheme slate
colorscheme desert

" Highlight cursor line.
set cursorline

" Keep one line below cursor when scrolling.
set scrolloff=1

" Allow mouse scrolling and text selection.
set mouse=a

" Allow for cursor beyond last character.
set virtualedit=onemore

" Enable linebreak.
set linebreak
" Show '+++' at beginning of broken line.
set showbreak=+++

" Enable autoindent.
set autoindent
" Enable C-indent.
set smartindent
" Amount of spaces for autoindent.
set shiftwidth=2
" Set smartindent.
set smarttab
" Convert tab to spaces.
set expandtab
" Amount of spaces for tab.
set softtabstop=2
set tabstop=2

" Show hidden characters.
set list
" But only tabs and trailing whitespace.
set listchars=tab:>·,trail:·

" Enable incremental search.
set incsearch
" Highlight the found search terms.
set hlsearch

" If search term contains uppercase characters, do a case sensitive search.
set ignorecase
" Else, ignore cases.
set smartcase

" Show matching brackets.
set showmatch

" Show incomplete commands.
set showcmd

" Disables automatic commenting on newline.
autocmd FileType * setlocal formatoptions=cjqt

" Completion.
set completeopt=menuone
set omnifunc=syntaxcomplete#Complete

" Enable Tab completion for the command line.
set wildmenu
set wildmode=longest:full,full
if v:version >= 900
  set wildoptions=pum
endif
" Ignore certain files.
set wildignore+=*/tmp/*,*.so,*.swp,*.swo,*.zip,.git,.cabal-sandbox,*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx,*/node_modules/**,*/.venv/**,*/vendor/**,*/target/**,*/.git/**,*/.hg/**,*/.svn/**,*/dist/**,*/dist/assets/**,*.min.js

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Splits behaviour:
" Splits open at the bottom and right.
set splitbelow
set splitright

" Set up backups swap.
if !isdirectory($HOME.'/.vim/undodir')
  call mkdir($HOME.'/.vim/undodir', 'p', 0700)
endif
" Keep track of undos for all files in following directory only.
set undodir=~/.vim/undodir
set undofile

" Set up swap.
if !isdirectory($HOME.'/.vim/swap')
  call mkdir($HOME.'/.vim/swap', 'p', 0700)
endif
" Keep swap files in following directory only.
set directory=~/.vim/swap

" Delete local backup since everything is stored centrally.
set nobackup
set nowritebackup

" Dont remove buffer when tab is closed.
set hidden

" Define a function to remove trailing whitespace.
fun! TrimTrailingWhitespace()
  if !&binary && &filetype != 'diff'
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
  endif
endfun

augroup vimrc
  " Remove all autocommands for the current group.
  au!
  " Jump to the last known cursor position.
  " Don't when the position is invalid, when inside an event handler and for a commit message.
  autocmd BufReadPost *
        \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
        \ |   exe "normal! g`\""
        \ | endif
  " Call the function defined above to remove trailing whitespace on save.
  autocmd BufWritePre * :call TrimTrailingWhitespace()
augroup END

" Set up skeletons.
augroup skeletons
  au!
  autocmd BufNewFile *.* silent! execute '0r ~/.vim/templates/skeleton.'.expand('<afile>:e')
augroup END

" Auto create directories on save.
augroup auto_mkdir
  autocmd!
  autocmd BufWritePre * if !isdirectory(expand('%:p:h')) | call mkdir(expand('%:p:h'), 'p') | endif
augroup END

" Netrw.
" Hide banner.
let g:netrw_banner=0
" Tree-style view.
let g:netrw_liststyle=3
" Open files in previous window.
let g:netrw_browse_split=4
" Open splits to the left.
let g:netrw_altv=1
" Set split width.
let g:netrw_winsize=30
" Toggle Netrw.
function! ToggleNetrw()
  if exists("t:netrw_open") && t:netrw_open
    let t:netrw_open = 0
    close
  else
    let t:netrw_open = 1
    leftabove 30vsplit .
  endif
endfunction
nnoremap <silent> <C-n> :call ToggleNetrw()<CR>

" Grep.
function! GrepPrompt()
  let l:word = expand('<cword>')
  let l:search = input('Grep for: ', l:word)
  if !empty(l:search)
    execute 'vimgrep /' . escape(l:search, '/\') . '/gj **/*'
    copen
  endif
endfunction

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.

set signcolumn=yes

" Change cursor from beam to block depending on mode.
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

" Always show the statusline
set laststatus=2
" Start with a clean statusline
set statusline=
" Change highlight group
set statusline+=%#TabLineSel#
" Show current mode (Normal, Insert, etc.)
set statusline+=\ %{mode()}
" Show file name
set statusline+=\ %f
" Show modified flag [+] if the file is modified
set statusline+=%m
" Show readonly flag [RO] if the file is readonly
set statusline+=%r
" Change highlight group
set statusline+=%#TabLineFill#
" Powerline separator
set statusline+=
" Split the statusline into left and right sections
set statusline+=%=
" Powerline separator
set statusline+=
" Change highlight group
set statusline+=%#TabLineSel#
" Show file encoding
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
" Show filetype
set statusline+=\ %y
" Show line and column number
set statusline+=\ %l:%c
" Show percentage through the file
set statusline+=\ %p%%

"""""""""""""""""""""""""""
" LANGUAGE SPECIFIC STUFF "
"""""""""""""""""""""""""""

" Python.
" Max textwidth until line break (python standard = 79).
" Also show hint for max line width. And comply to PEP8.
autocmd FileType python setlocal softtabstop=4 tabstop=4 shiftwidth=4 expandtab smarttab autoindent smartindent colorcolumn=80

" HTML.
" Treat <li> and <p> tags like the block tags they are.
let g:html_indent_tags = 'li\|p'
autocmd FileType html setlocal softtabstop=2 tabstop=2 shiftwidth=2 expandtab autoindent smartindent

" CSS.
" Words are exetracted by iskeyword option of buffer. Adjust it by:
autocmd FileType css setlocal iskeyword+=- softtabstop=2 tabstop=2 shiftwidth=2 expandtab autoindent smartindent
" For scss files to add @ to iskeyword option.
autocmd FileType scss setlocal iskeyword+=@-@ softtabstop=2 tabstop=2 shiftwidth=2 expandtab autoindent smartindent

" JS.
autocmd FileType javascript setlocal softtabstop=2 tabstop=2 shiftwidth=2 expandtab autoindent smartindent

" JSON.
autocmd FileType json setlocal softtabstop=2 tabstop=2 shiftwidth=2 expandtab autoindent smartindent
autocmd FileType jsonc setlocal softtabstop=2 tabstop=2 shiftwidth=2 expandtab autoindent smartindent

" Java.
autocmd FileType java setlocal softtabstop=2 tabstop=2 shiftwidth=2 expandtab autoindent smartindent

" Markdown.
autocmd FileType markdown setlocal softtabstop=2 tabstop=2 shiftwidth=2 textwidth=79

"""""""""""""""
" KEYBINDINGS "
"""""""""""""""

" Commands.

" Fix some common command typos.
cabbrev Q q
cabbrev W w

cabbrev WQ wq
cabbrev Wq wq
cabbrev wQ wq

cabbrev qw wq
cabbrev qW wq
cabbrev Qw wq
cabbrev QW wq

cabbrev qA qa
cabbrev QA qa
cabbrev Qa qa

" Ex Mode is annoying.
noremap Q <Nop>

" Enable to edit protected files.
cnoremap w!! w !sudo tee %

" Search.

" Remove last search highlighting.
nnoremap <silent><ESC> :noh<CR><ESC>

" Registers.

" Prevent selecting and pasting from overwriting what's originally copied.
vnoremap <silent>p "_dP
xnoremap <silent>p pgvy

" Keep cursor at the bottom of the visual selection after yanking it.
vnoremap <silent>y ygv<ESC>

" Navigation.

" Goto start/end of line/document.
noremap <silent>H 0
noremap <silent>J G
noremap <silent>K gg
noremap <silent>L $

noremap <silent><S-Left>  0
noremap <silent><S-Down>  G
noremap <silent><S-Up>    gg
noremap <silent><S-Right> $

" Don't skip line wraps while moving over them.
noremap <silent>j gj
noremap <silent>k gk

noremap <silent><Down> gj
noremap <silent><Up>   gk

inoremap <silent><Down> <C-o>gj
inoremap <silent><Up>   <C-o>gk

" Stay in indent mode.
vnoremap <silent>< <gv
vnoremap <silent>> >gv

" Move text up and down.
nnoremap <silent><ESC><C-j> :m .+1<CR>==
nnoremap <silent><ESC><C-k> :m .-2<CR>==

vnoremap <silent><ESC><C-j> :m '<+1<CR>==
vnoremap <silent><ESC><C-k> :m '>-2<CR>==

xnoremap <silent><ESC><C-j> :m '>+1<CR>gv-gv
xnoremap <silent><ESC><C-k> :m '<-2<CR>gv-gv

" Splits.

" Open up new vertical/horizontal split.
nnoremap <silent><ESC>v :vsplit<CR>
nnoremap <silent><ESC>b :split<CR>

" Close current split.
nnoremap <silent><ESC>s :close<CR>

" Swap splits positions.
nnoremap <silent><ESC>x <C-w>x

" Move splits.
nnoremap <silent><ESC>y <C-w><S-h>
nnoremap <silent><ESC>c <C-w><S-k>
nnoremap <silent><ESC><S-y> <C-w><S-l>
nnoremap <silent><ESC><S-c> <C-w><S-j>

" Navigate splits.
noremap <silent><C-h> <C-w>h
noremap <silent><C-j> <C-w>j
noremap <silent><C-k> <C-w>k
noremap <silent><C-l> <C-w>l

noremap <silent><C-Left>  <C-w>h
noremap <silent><C-Down>  <C-w>j
noremap <silent><C-Up>    <C-w>k
noremap <silent><C-Right> <C-w>l

" Resize splits.
noremap <silent><M-Left>  :vertical resize -1<CR>
noremap <silent><M-Down>  :resize -1<CR>
noremap <silent><M-Up>    :resize +1<CR>
noremap <silent><M-Right> :vertical resize +1<CR>

noremap <silent><ESC>h :vertical resize -1<CR>
noremap <silent><ESC>j :resize -1<CR>
noremap <silent><ESC>k :resize +1<CR>
noremap <silent><ESC>l :vertical resize +1<CR>

" Tabs.

" Open new tab.
nnoremap <silent><leader>w :tabnew<CR>
" Select next tab.
nnoremap <silent><leader><S-Tab> gT
" Select previous tab.
nnoremap <silent><leader><Tab> gt
" Close current tab.
nnoremap <silent><leader>q :tabclose<CR>
" Go to tab 1-9.
for i in range(1, 9)
  execute 'nnoremap <silent><leader>' . i . ' ' . i . 'gt'
endfor
nnoremap <silent><leader>z :ls<CR>

" Buffers.

" Open new buffer.
nnoremap <silent><ESC>w :enew<CR>
" Select next buffer.
nnoremap <silent><ESC><Tab> :bn<CR>
" Select previous buffer.
nnoremap <silent><ESC><S-Tab> :bp<CR>
" Close current buffer.
nnoremap <silent><ESC>q :bd!<CR>
" Go to buffer 1-9.
for i in range(1, 9)
  execute 'nnoremap <silent><ESC>' . i . ' :buffer ' . i . '<CR>'
endfor
nnoremap <silent><ESC>z :tabs<CR>

" Terminal.
let g:toggle_term = "<C-t>"

let s:term_buf_nr = -1
function! g:ToggleTerminal() abort
  if s:term_buf_nr == -1
    execute "botright terminal"
    let s:term_buf_nr = bufnr("$")
  else
    try
      execute "bdelete! " . s:term_buf_nr
    catch
      let s:term_buf_nr = -1
      call <SID>ToggleTerminal()
      return
    endtry
    let s:term_buf_nr = -1
  endif
endfunction

execute "nnoremap <silent>".g:toggle_term ." :call ToggleTerminal()<CR>"
execute "tnoremap <silent>".g:toggle_term ." <C-w>:call ToggleTerminal()<CR>"

" Move between terminal and other splits.
tnoremap <C-h> <C-w>h
tnoremap <C-j> <C-w>j
tnoremap <C-k> <C-w>k
tnoremap <C-l> <C-w>l

tnoremap <C-Left>  <C-w>h
tnoremap <C-Down>  <C-w>j
tnoremap <C-Up>    <C-w>k
tnoremap <C-Right> <C-w>l

" Netrw.
nnoremap <silent> <C-n> :call ToggleNetrw()<CR>

" Grep.
nnoremap <leader>g :call GrepPrompt()<CR>

" Diagnostics.

" Next/previous error.
nnoremap <leader>n :cnext<CR>
nnoremap <leader>b :cprev<CR>

" Show undo list.

nnoremap <leader>u :undolist<CR>

" Formatting.
nnoremap <leader>f gg=G``
vnoremap <leader>f ='

" Auto-close parentheses
inoremap ( ()<Left>
inoremap [ []<Left>
inoremap { {}<Left>

" Auto-close quotes
inoremap ' ''<Left>
inoremap " ""<Left>
inoremap ` ``<Left>

" Other.

" Place date and time string at current cursor position.
nnoremap <silent><leader>d i<C-R>=strftime('%c')<CR><ESC>
" Replace selection with date and time string.
vnoremap <silent><leader>d c<C-R>=strftime('%c')<CR><ESC>

" Completion.
inoremap <expr> <Tab>    pumvisible() ? "\<C-n>" : (col('.') > 1 && getline('.')[col('.')-2] =~ '\S' ? "\<C-x>\<C-o>" : "\<Tab>")
inoremap <expr> <S-Tab>  pumvisible() ? "\<C-p>" : "\<C-d>"
inoremap <expr> <C-@>    pumvisible() ? '' : "\<C-x>\<C-o>"
inoremap <expr> <CR>     pumvisible() ? "\<C-y>" : "\<CR>"
