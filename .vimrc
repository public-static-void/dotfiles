""""""""""""
" ~/.vimrc "
""""""""""""

"""""""""""
" PLUGINS "
"""""""""""

" Turn off filetype detection for a second. Will be turned back on later on.
filetype off

" Use vim-plug to take care of plugin management.
" Check for curl and vim-plug to be installed. Install vim-plug if its not.
let vimplug_exists=expand('~/.vim/autoload/plug.vim')
let curl_exists=expand('curl')
if !filereadable(vimplug_exists)
    if !executable(curl_exists)
        echoerr 'You have to install curl or first install vim-plug yourself!'
        execute 'q!'
    endif
    echo 'Installing Vim-Plug...'
    echo ''
    silent exec '!'curl_exists' -fLo ' . shellescape(vimplug_exists) . ' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    let g:not_finish_vimplug = 'yes'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC | q
endif

" Auto install plugins on startup.
autocmd VimEnter *
    \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
    \|     PlugInstall --sync | source $MYVIMRC | q
    \| endif

call plug#begin(expand('~/.vim/plugged'))

" Install plugins:
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'ryanoasis/vim-devicons'

Plug 'kassio/neoterm'

Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }

Plug 'Yggdroot/indentLine'
Plug 'sheerun/vim-polyglot'
Plug 'fisadev/vim-isort'
Plug 'tpope/vim-commentary'
Plug 'luochen1990/rainbow'

Plug 'dense-analysis/ale'

Plug 'Shougo/deoplete.nvim'
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'

Plug 'jiangmiao/auto-pairs'

Plug 'python-rope/ropevim'

Plug 'othree/html5.vim'
Plug 'alvan/vim-closetag'
Plug 'valloric/MatchTagAlways'

Plug 'pangloss/vim-javascript'

Plug 'mhinz/vim-startify'

Plug 'zacanger/angr.vim'
Plug 'tomasiser/vim-code-dark'

" Initialize plugin system
call plug#end()

""""""""""""""""""""
" GENERAL SETTINGS "
""""""""""""""""""""

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
let mapleader = ','

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
" colorscheme angr
colorscheme codedark

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
autocmd FileType * setlocal formatoptions=cjoqt

" Enable Tab completion for the command line.
set wildmenu
set wildmode=longest:list,full
" Ignore certain files.
set wildignore+=*/tmp/*,*.so,*.swp,*.swo,*.zip,.git,.cabal-sandbox,*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx

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

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.

set signcolumn=yes

" Change cursor from beam to block depending on mode.
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

""""""""""""""""""""""""""""
" PLUGIN SPECIFIC SETTINGS "
""""""""""""""""""""""""""""

" vim-airline
let g:airline_theme = 'kalisi'

let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#ale#enabled = 1
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" Airline unicode symbols.
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''

" Airline nerdfont symbols.
let g:airline_symbols.space = ' '
let g:airline_symbols.modified = '樂'
let g:airline_symbols.whitespace = 'Ξ'
let g:airline_symbols.branch = ''
let g:airline_symbols.ellipsis= ''
let g:airline_symbols.paste= ''
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.spell = '暈'
let g:airline_symbols.linenr = ''
let g:airline_symbols.dirty = ' '
let g:airline_symbols.colnr = ''
let g:airline_symbols.keymap = ''
let g:airline_symbols.crypt = ''
let g:airline_symbols.notexists = ' '

" NERDTree settings:
" Set size.
let g:NERDTreeWinSize = 30
" Show hidden files by default.
let NERDTreeShowHidden = 1
let g:NERDTreeDirArrowExpandable = '►'
let g:NERDTreeDirArrowCollapsible = '▼'
let NERDTreeShowLineNumbers = 0
let NERDTreeShowHidden = 1
let NERDTreeMinimalUI = 1

" Set Ctrl+N to open NERDTree plugin.
" Open NERDTree in the directory of the current file (or /home if no file is open)
nmap <silent> <C-n> :call NERDTreeToggleInCurDir()<CR>
function! NERDTreeToggleInCurDir()
  " If NERDTree is open in the current buffer

    if len(filter(range(1, bufnr('$')), '! empty(bufname(v:val)) &&         buflisted(v:val)')) != 1
        exe ':NERDTreeToggle'
    elseif (exists('t:NERDTreeBufName') && bufwinnr(t:NERDTreeBufName) != -1)
        exe ':NERDTreeClose'
    else
        exe ':NERDTreeFind'
    endif
endfunction

" Autostart NERDTree with vim.
" autocmd StdinReadPre * let s:std_in=1
" autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" Variables to change custom git status symbols.
let g:NERDTreeGitStatusIndicatorMapCustom = {
            \ 'Modified'  :'',
            \ 'Staged'    :'',
            \ 'Untracked' :'',
            \ 'Renamed'   :'',
            \ 'Unmerged'  :'',
            \ 'Deleted'   :'',
            \ 'Dirty'     :'',
            \ 'Ignored'   :'',
            \ 'Clean'     :'',
            \ 'Unknown'   :'?',
            \ }
" Predefined map used nerdfonts.
let g:NERDTreeGitStatusUseNerdFonts = 1 " you should install nerdfonts by yourself. default: 0

" Hide the boring brackets([ ]).
let g:NERDTreeGitStatusConcealBrackets = 1 " default: 0

" IndentLine settings.
" Exclude filetypes from showing indentation.
let g:indentLine_fileTypeExclude = ['help', 'diff', 'nerdtree', 'markdown']
" Exclude buffertypes from showing indentation.
let g:indentLine_bufTypeExclude = ['help', 'terminal', 'nofile']

" Let plugin override cursor concealing settings except in vidual mode.
let g:indentLine_setConceal = 1
let g:indentLine_concealcursor = 'inc'

" Show dot character to indicate spaces.
let g:indentLine_leadingSpaceEnabled = 1
let g:indentLine_leadingSpaceChar = '·'

" Hexokinase settings.
" Color Patterns to match for all filetypes.
let g:Hexokinase_optInPatterns = [
            \ 'full_hex',
            \ 'triple_hex',
            \ 'rgb',
            \ 'rgba',
            \ 'hsl',
            \ 'hsla'
            \ ]

" Make sure neoterm starts in horizontal split.
let g:neoterm_default_mod='belowright'

" Gitgutter keymaps.
nnoremap <silent><leader>k :GitGutterPreviewHunk<CR>
nnoremap <silent><leader>j :GitGutterNextHunk<CR>
nnoremap <silent><leader>h :GitGutterPrevHunk<CR>

" Rainbow.
let g:rainbow_active = 1

" ALE.
" let g:ale_completion_enabled = 1

nnoremap <silent><leader>f :ALEFix trim_whitespace<CR>:ALEFix remove_trailing_lines<CR>
nnoremap <silent><leader>n :ALENext<CR>
nnoremap <silent><leader>b :ALEPrevious<CR>
nnoremap <silent><leader>v :lopen<CR>
nnoremap <silent><TAB> :ALEHover<CR>
nnoremap <silent>gd :ALEGoToDefinition<CR>
nnoremap <silent>gi :ALEGoToImplementation<CR>
nnoremap <silent>gr :ALEFindReferences<CR>
nnoremap <silent>gs :ALEGoToTypeDefinition<CR>
nnoremap <silent><leader>r :ALERename<CR>
nnoremap <silent><leader>a :ALECodeAction<CR>
nnoremap <silent><leader>m :ALEDetail<CR>

" Deoplete.
let g:deoplete#enable_at_startup = 1

" Startify.
    let g:startify_custom_header = [
\'                                .                        ',
\'                               @88>                      ',
\'             ...     ..        %8P      ..    .     :    ',
\'          :~""888h.:^"888:      .     .888: x888  x888.  ',
\'         8X   `8888X  8888>   .@88u  ~`8888~`888X`?888f` ',
\'        X888n. 8888X  ?888>   "888E`   X888  888X ´888>  ',
\'        `88888 8888X   ?**h.   888E    X888  888X |888>  ',
\'          `*88 8888~ x88x.     888E    X888  888X |888>  ',
\'         ..<"  88*`  88888X    888E    X888  888X l888>  ',
\'            ..XC.    `*8888k   888&   "*88%""*88" `888!` ',
\'          :888888H.    `%88>   R888"    `~    "    `"`   ',
\'         <  `"888888:    X"     ""                       ',
\'               %888888x.-`                               ',
\'                 ""**""                                  ',]

"""""""""""""""""""""""""""
" LANGUAGE SPECIFIC STUFF "
"""""""""""""""""""""""""""

" #Python.
" Max textwidth until line break (python standard = 79).
" Also show hint for max line width. And comply to PEP8.
autocmd FileType python setlocal softtabstop=4 tabstop=4 shiftwidth=4 expandtab autoindent smartindent textwidth=79 colorcolumn=80

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
autocmd FileType java setlocal softtabstop=4 tabstop=4 shiftwidth=4 expandtab autoindent smartindent

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
noremap <silent><C-a> :tabnew<CR>
" Select next tab.
nnoremap <silent><C-s> gT
" Select previous tab.
nnoremap <silent><C-d> gt
" Close current tab.
nnoremap <silent><C-f> :tabclose<CR>

" Buffers.

" Open new buffer.
nnoremap <silent><ESC>a :enew<CR>
" Select next buffer.
nnoremap <silent><ESC>s :bn<CR>
" Select previous buffer.
nnoremap <silent><ESC>d :bp<CR>
" Close current buffer.
nnoremap <silent><ESC>f :bd<CR>

" Terminal.

" Toggle neoterm terminal.
noremap  <silent><C-t> :Ttoggle <CR>
tnoremap <silent><C-t> exit <CR>

" Move between terminal and other splits.
tnoremap <C-h> <C-w>h
tnoremap <C-j> <C-w>j
tnoremap <C-k> <C-w>k
tnoremap <C-l> <C-w>l

tnoremap <C-left>  <C-w>h
tnoremap <C-down>  <C-w>j
tnoremap <C-up>    <C-w>k
tnoremap <C-right> <C-w>l

" Other.

" Place date and time string at current cursor position
nnoremap <silent><leader>d i<C-R>=strftime('%c')<CR><ESC>
" Replace selection with date and time string
vnoremap <silent><leader>d c<C-R>=strftime('%c')<CR><ESC>

" Completion
imap <C-@> <C-n>
inoremap <silent><expr> <TAB> pumvisible()? "\<C-n>" : "<TAB>"
inoremap <silent><expr> <S-TAB> pumvisible()? "\<C-p>" : "<S-TAB>"
" Make <Enter> key select the highlighted menu item when the popup menu is visible."
inoremap <silent><expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
