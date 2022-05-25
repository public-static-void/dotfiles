""""""""""""
" ~/.vimrc "
""""""""""""

""""""""""""""""""""
" GENERAL SETTINGS "
""""""""""""""""""""

" Disable compatibility with vi which can cause unexpected issues.
" Must be first line.
set nocompatible

" Set encoding to UTF-8.
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8
scriptencoding utf-8

" Disable sound.
set belloff=all

" Set terminal. Fixes some key press bugs.
set term=rxvt-unicode-256color
set t_Co=256

" Enable pathogen plugin manager.
execute pathogen#infect()

" Use vim8+'s native package manager to load plugins as well.
"packloadall

" Allow plugins to determine indentation.
filetype plugin indent on

" Change vim's updatetime option; the default value is 4000, i.e. 4 seconds.
set updatetime=100

" Automatically set current directory to file's location.
set autochdir

" Watch for file changes.
set autoread

" Enable system clipboard for copy/paste from/to outside vim.
"set clipboard=unnamedplus,autoselect

" Remove buffer when close a tab.
set nohidden

" Enable syntax highlighting.
syntax on

" Show the file name in the terminal title bar.
set title

" Enable line numbers.
set number
set relativenumber
set numberwidth=5

" Show row and column information.
set ruler

" Always show tabs-bar.
set showtabline=2

" Disable modelines as a security precaution
set modelines=0
set nomodeline

" Uncomment to prevent non-normal modes showing in powerline and below powerline.
set noshowmode

" Enable powerline.
let $PYTHONPATH='/usr/lib/python3.10/site-packages'
set rtp+=/usr/lib/python3.10/site-packages/powerline/bindings/vim/
set laststatus=2

" Colors.
"colorscheme wal
colorscheme angr            " top
"colorscheme codedark       " top
"colorscheme apprentice     " top

" Makes every background transparent.
highlight NonText     term=NONE ctermfg=NONE ctermbg=NONE guifg=NONE guibg=NONE
highlight Normal      term=NONE ctermfg=NONE ctermbg=NONE guifg=NONE guibg=NONE
highlight LineNr      term=NONE ctermfg=NONE ctermbg=NONE guifg=NONE guibg=NONE
highlight signcolumn  term=NONE ctermfg=NONE ctermbg=NONE guifg=NONE guibg=NONE
highlight ErrorMsg    term=NONE ctermfg=NONE ctermbg=NONE guifg=NONE guibg=NONE
highlight EndOFBuffer term=NONE ctermfg=NONE ctermbg=NONE guifg=NONE guibg=NONE

" Highlight cursor line.
set cursorline

" Keep one line below cursor when scrolling.
set scrolloff=1

" Allow mouse scrolling in normal, insert and command modes and text selection in visual mode only.
set mouse=nic

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
set shiftwidth=4
" Set smartindent.
set smarttab
" Convert tab to spaces.
set expandtab
" Amount of spaces for tab.
set softtabstop=4

" Show hidden characters.
set list
" But only tabs and trailing whitespace.
set listchars=tab:>·,trail:·

" Enable incremental search.
set incsearch
" Highlight the found search terms.
set hlsearch

" Show matching brackets.
set showmatch

" Show incomplete commands.
set showcmd

" Enable omni completion.
set omnifunc=syntaxcomplete#Complete

" Add spellcheck and keywords to autocompletion.
set complete+=spell,keyword
" Let popup menu insert the longest common text of all matches instead of selecting the first completion item, and make the menu come up even if there's only one match.
set completeopt+=longest,menuone

" Disables automatic commenting on newline.
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Enable Tab completion for the command line.
set wildmenu
"set wildmode=list:longest,full
set wildmode=longest,list,full
" Ignore certain files.
set wildignore+=*/tmp/*,*.so,*.swp,*.swo,*.zip,.git,.cabal-sandbox,*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx

" Splits behaviour:
" Splits open at the bottom and right.
set splitbelow
set splitright

" Set up backups.
set backup                      " Backups are nice ...
    if has('persistent_undo')
        set undofile            " So is persistent undo ...
        set undolevels=1000     " Maximum number of changes that can be undone
        set undoreload=10000    " Maximum number lines to save for undo on a buffer reload
    endif

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
  autocmd BufNewFile *.* silent! execute '0r ~/.vim/templates/skeleton.'.expand("<afile>:e")
augroup END

""""""""""""""""""""""""""""
" PLUGIN SPECIFIC SETTINGS "
""""""""""""""""""""""""""""

" NERDTree settings:
" Set size.
let g:NERDTreeWinSize=30
" Show hidden files by default.
let NERDTreeShowHidden=1

let g:NERDTreeDirArrowExpandable = '►'
let g:NERDTreeDirArrowCollapsible = '▼'
let NERDTreeShowLineNumbers=1
let NERDTreeShowHidden=1
let NERDTreeMinimalUI = 1
let g:NERDTreeWinSize=38

" Autostart NERDTree with vim.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" Variables to change custom git status symbols.
let g:NERDTreeGitStatusIndicatorMapCustom = {
                \ 'Modified'  :'',
                \ 'Staged'    :'',
                \ 'Untracked' :'',
                \ 'Renamed'   :'',
                \ 'Unmerged'  :'',
                \ 'Deleted'   :'',
                \ 'Dirty'     :'',
                \ 'Ignored'   :'',
                \ 'Clean'     :'',
                \ 'Unknown'   :'?',
                \ }
" Predefined map used nerdfonts.
let g:NERDTreeGitStatusUseNerdFonts = 1 " you should install nerdfonts by yourself. default: 0

" Show ignored status.
"let g:NERDTreeGitStatusShowIgnored = 1 " a heavy feature may cost much more time. default: 0

" Indicate every single untracked file under an untracked dir.
"let g:NERDTreeGitStatusUntrackedFilesMode = 'all' " a heavy feature too. default: normal

" Show Clean indicator.
"let g:NERDTreeGitStatusShowClean = 1 " default: 0

" Hide the boring brackets([ ]).
let g:NERDTreeGitStatusConcealBrackets = 1 " default: 0

" Always show gitgutter.
set signcolumn=yes

" Prettier plugin configurations:
" Enable auto formatting of files that have "@format" or "@prettier" tag.
let g:prettier#autoformat = 1

"Allow auto formatting also for files without "@format" or "@prettier" tag.
" The previous line is still required for this one to work.
let g:prettier#autoformat_require_pragma = 0

" Make prettier async.
let g:prettier#exec_cmd_async = 1

" By default parsing errors will open the quickfix but can also be disabled.
let g:prettier#quickfix_enabled = 0

" IndentLine settings.
" Exclude filetypes from showing indentation.
let g:indentLine_fileTypeExclude = ["help", "diff", "nerdtree"]
" Exclude buffertypes from showing indentation.
let g:indentLine_bufTypeExclude = ["help", "terminal", "nofile"]

" Let plugin override cursor concealing settings except in vidual mode.
let g:indentLine_setConceal = 1
let g:indentLine_concealcursor = "inc"

" Show dot character to indicate spaces.
let g:indentLine_leadingSpaceEnabled = 1
let g:indentLine_leadingSpaceChar = "·"

"""""""""""""""""""""""""""
" LANGUAGE SPECIFIC STUFF "
"""""""""""""""""""""""""""

" #Python.
" Max textwidth until line break (python standard = 79).
" Also show hint for max line width. And comply to PEP8.
autocmd FileType python setlocal softtabstop=4 tabstop=4 shiftwidth=4 textwidth=79 formatoptions+=t colorcolumn=80

" HTML.
" Treat <li> and <p> tags like the block tags they are.
let g:html_indent_tags = 'li\|p'

"""""""""""""""
" KEYBINDINGS "
"""""""""""""""

" Leader key variable.
let mapleader = ","

" Remap start/end of line/document to H,L,J,K.
map H 0
map L $
map J G
map K gg

" Don't skip line wraps while moving over them.
nnoremap j gj
nnoremap k gk

" Remap some command typos.
:command W w
:command Q q
:command WQ wq
:command Wq wq
:command QA qa
:command Qa qa

" Remap split navigation to Ctrl+H,J,K,L.
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
" Do the same for the arrowkeys.
map <C-left>  <C-w>h
map <C-down>  <C-w>j
map <C-up>    <C-w>k
map <C-right> <C-w>l
" And also for for the built-in terminal.
tmap <C-h> <C-w>h
tmap <C-j> <C-w>j
tmap <C-k> <C-w>k
tmap <C-l> <C-w>l
" Again the same for the arrowkeys in the terminal.
tmap <C-left>  <C-w>h
tmap <C-down>  <C-w>j
tmap <C-up>    <C-w>k
tmap <C-right> <C-w>l

" Remap split resize keys to Alt+arrowkeys.
map <M-up>    :resize -1<CR>
map <M-down>  :resize +1<CR>
map <M-left>  :vertical resize -1<CR>
map <M-right> :vertical resize +1<CR>
" Also for hjkl. <Esc> corresponds to the escape sequence generated by pressing Alt in combination with hjkl in the terminal.
map <Esc>k :resize -1<CR>
map <Esc>j :resize +1<CR>
map <Esc>h :vertical resize -1<CR>
map <Esc>l :vertical resize +1<CR>

" Open a new tab with Ctrl-A.
map <C-A> :tabnew<CR>

" Ctrl-S to select next tab.
nmap <C-s> gT

" Ctrl-D to select previous tab
nmap <C-d> gt

" Ctrl-F to close tab.
nmap <C-f> :tabclose<CR>

" Start built-in terminal with Ctrl+T.
map <C-T> :terminal<CR>

" Exit built-in terminal with Ctrl-T as well.
tmap <C-T> <C-w>:q!<CR>

" Set Ctrl+N to open NERDTree plugin.
" Open NERDTree in the directory of the current file (or /home if no file is open)
nmap <silent> <C-n> :call NERDTreeToggleInCurDir()<cr>
function! NERDTreeToggleInCurDir()
  " If NERDTree is open in the current buffer
  if (exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1)
    exe ":NERDTreeClose"
  else
    exe ":NERDTreeFind"
  endif
endfunction

" Make <Enter> key select the highlighted menu item when the popup menu is visible.
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Remove last search highlighting with Escape.
nnoremap <silent><esc> :noh<return><esc>

" Autocomplete parenthesis, brackets and braces.
inoremap ( ()<Left>
inoremap [ []<Left>
inoremap { {}<Left>

" Autocomplete quotes.
inoremap ` ``<Left>
inoremap " ""<Left>
inoremap ' ''<Left>

" Keep selection after indenting in visual mode.
vmap < <gv
vmap > >gv
