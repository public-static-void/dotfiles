"""""""""""""""""""""""""""
" ~/.config/nvim/init.vim "
"""""""""""""""""""""""""""

"""""""""""
" PLUGINS "
"""""""""""

" Turn off filetype detection for a second. Will be turned back on later on.
filetype off

" Use vim-plug to take care of plugin management.
" Check for curl and vim-plug to be installed. Install vim-plug if its not.
let vimplug_exists=expand('~/.config/nvim/autoload/plug.vim')
let curl_exists=expand('curl')
if !filereadable(vimplug_exists)
    if !executable(curl_exists)
        echoerr "You have to install curl or first install vim-plug yourself!"
        execute "q!"
    endif
    echo "Installing Vim-Plug..."
    echo ""
    silent exec "!"curl_exists" -fLo " . shellescape(vimplug_exists) . " --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
    let g:not_finish_vimplug = "yes"
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC | q
endif

" Auto install plugins on startup.
autocmd VimEnter *
    \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
    \|     PlugInstall --sync | source $MYVIMRC | q
    \| endif

call plug#begin(expand('~/.config/nvim/plugged'))

" Install plugins:
Plug 'neoclide/coc.nvim', {'branch': 'release'}

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
Plug 'https://github.com/tpope/vim-commentary'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

Plug 'python-rope/ropevim'

Plug 'othree/html5.vim'
Plug 'alvan/vim-closetag'
Plug 'valloric/MatchTagAlways'

Plug 'pangloss/vim-javascript'

Plug 'p00f/nvim-ts-rainbow'

Plug 'zacanger/angr.vim'
Plug 'tomasiser/vim-code-dark'
Plug 'itspriddle/vim-themes'
Plug 'srcery-colors/srcery-vim'
Plug 'KabbAmine/yowish.vim'
Plug 'habamax/vim-saturnite'
Plug 'mhinz/vim-janah'

" Initialize plugin system
call plug#end()

" Install Coc extentions.
let g:coc_global_extensions = [
    \'coc-json',
    \'coc-pairs',
    \'coc-tsserver',
    \'coc-eslint',
    \'coc-html',
    \'coc-emmet',
    \'coc-css',
    \'coc-prettier',
    \'coc-jedi',
    \'coc-pyright',
    \'coc-pydocstring',
    \'coc-java',
    \'coc-sh',
    \'coc-highlight'
    \]

""""""""""""""""""""
" GENERAL SETTINGS "
""""""""""""""""""""

" Set encoding to UTF-8.
set encoding=utf-8
"set fileencoding=utf-8
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
let mapleader = ","

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
colorscheme angr
" colorscheme saturnite
" colorscheme codedark
" colorscheme sunburst
" colorscheme srcery
" colorscheme yowish
" colorscheme janah

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
set shiftwidth=4
" Set smartindent.
set smarttab
" Convert tab to spaces.
set expandtab
" Amount of spaces for tab.
set softtabstop=4
set tabstop=4

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
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Enable Tab completion for the command line.
set wildmenu
set wildmode=list:full
" Ignore certain files.
set wildignore+=*/tmp/*,*.so,*.swp,*.swo,*.zip,.git,.cabal-sandbox,*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Splits behaviour:
" Splits open at the bottom and right.
set splitbelow
set splitright

" Set up backups swap.
if !isdirectory($HOME."/.local/share/nvim/undodir")
    call mkdir($HOME."/.local/share/nvim/undodir", "p", 0700)
endif
" Keep track of undos for all files in following directory only.
set undodir=~/.local/share/nvim/undodir
set undofile

" Set up swap.
if !isdirectory($HOME."/.local/share/nvim/swap")
    call mkdir($HOME."/.local/share/nvim/swap", "p", 0700)
endif
" Keep swap files in following directory only.
set directory=~/.local/share/nvim/swap

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
  autocmd BufNewFile *.* silent! execute '0r ~/.config/nvim/templates/skeleton.'.expand("<afile>:e")
augroup END

" Fixes awesome/alacritty bug making nvim starting bugged.
autocmd VimEnter * call timer_start(20, { tid -> execute(':silent exec "!kill -s SIGWINCH $PPID"')})

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

""""""""""""""""""""""""""""
" PLUGIN SPECIFIC SETTINGS "
""""""""""""""""""""""""""""

" vim-airline
let g:airline_theme = "kalisi"

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
let NERDTreeShowLineNumbers = 1
let NERDTreeShowHidden = 1
let NERDTreeMinimalUI = 1

" Set Ctrl+N to open NERDTree plugin.
" Open NERDTree in the directory of the current file (or /home if no file is open)
nmap <silent> <C-n> :call NERDTreeToggleInCurDir()<CR>
function! NERDTreeToggleInCurDir()
  " If NERDTree is open in the current buffer
    if (exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1)
        exe ":NERDTreeClose"
    else
        exe ":NERDTreeFind"
    endif
endfunction

" Autostart NERDTree with vim.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

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

" CoC config.
" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Add (Neo)Vim's native statusline support.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c
" Use tab for trigger completion with characters ahead and navigate.
inoremap <silent><expr> <TAB>
    \ pumvisible() ? "\<C-n>" :
    \ CheckBackspace() ? "\<TAB>" :
    \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! CheckBackspace() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use Control-Space to trigger completion.
if has('nvim')
    inoremap <silent><expr> <c-space> coc#refresh()
else
    inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make Enter auto-select the first completion item and notify coc.nvim to format on enter.
inoremap <silent><expr> <CR> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Navigate diagnostics.
nmap <silent> <leader>b <Plug>(coc-diagnostic-prev)
nmap <silent> <leader>n <Plug>(coc-diagnostic-next)
" Show all diagnostics.
nmap <silent> <leader>v :CocDiagnostics<CR>

" Use TAB to show documentation in preview window.
nnoremap <silent> <TAB> :call ShowDocumentation()<CR>

function! ShowDocumentation()
    if CocAction('hasProvider', 'hover')
        call CocActionAsync('doHover')
    else
        call feedkeys('TAB', 'in')
    endif
endfunction

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Apply AutoFix to problem on the current line.
nmap <leader>q <Plug>(coc-fix-current)

" Apply codeAction to current line.
nmap <leader>a <Plug>(coc-codeaction-line)

" Apply codeAction to the selected region.
xmap <leader>a <Plug>(coc-codeaction-selected)<CR>
nmap <leader>a <Plug>(coc-codeaction-selected)<CR>

" Apply codeAction to the current buffer.
nmap <leader>s <Plug>(coc-codeaction)

" Format selected code.
xmap <leader>f <Plug>(coc-format-selected)<CR>
nmap <leader>f <Plug>(coc-format-selected)<CR>

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json,python setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Format current buffer.
nmap <leader>f :call CocActionAsync('format')<CR>

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

" Treesitter config.
function! TreesitterConfig()
lua << EOF
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = { "bash", "bibtex", "c", "cpp", "css", "html", "java", "javascript", "json", "latex", "lua", "python", "scss", "typescript", "vim", "yaml" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
  rainbow = {
    enable = true,
    -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
    extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
    max_file_lines = nil, -- Do not enable for files with more than n lines, int
    -- colors = {}, -- table of hex strings
    -- termcolors = {} -- table of colour name strings
  }
}
EOF
endfunction
call TreesitterConfig()

"""""""""""""""""""""""""""
" LANGUAGE SPECIFIC STUFF "
"""""""""""""""""""""""""""

" #Python.
" Max textwidth until line break (python standard = 79).
" Also show hint for max line width. And comply to PEP8.
autocmd FileType python setlocal softtabstop=4 tabstop=4 shiftwidth=4 expandtab autoindent smartindent textwidth=79 formatoptions+=t colorcolumn=80

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

"""""""""""""""
" KEYBINDINGS "
"""""""""""""""

" Remap some command typos.
:command W  w
:command Q  q
:command WQ wq
:command Wq wq
:command QA qa
:command Qa qa

" Enables to edit protected files.
cmap w!! w !sudo tee %

" Remap start/end of line/document to H,L,J,K.
map H 0
map J G
map K gg
map L $
" Same for arrow keys.
map <S-left>  0
map <S-down>  G
map <S-up>    gg
map <S-right> $

" Don't skip line wraps while moving over them.
nnoremap j gj
nnoremap k gk
" Same for arrow keys.
nnoremap <down> gj
nnoremap <up>   gk
" Same for visual mode.
vnoremap j gj
vnoremap k gk
" Same for arrow keys.
vnoremap <down> gj
vnoremap <up>   gk
" Same for insert mode.
inoremap <down> <C-o>gj
inoremap <up>   <C-o>gk

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
map  <C-a> :tabnew<CR>
" Ctrl-S to select next tab.
nmap <C-s> gT
" Ctrl-D to select previous tab.
nmap <C-d> gt
" Ctrl-F to close tab.
nmap <C-f> :tabclose<CR>

" Open a new buffer with Alt-A.
map  <M-a> :enew<CR>
" Alt-S to select next buffer.
nmap <M-s> :bn<CR>
" Alt-D to select previous buffer.
nmap <M-d> :bp<CR>
" Alt-F to close buffer.
nmap <M-f> :bd<CR>

" Open up splits with Alt-v abn Alt-b.
nmap <M-v> :vsplit<CR>
nmap <M-b> :split<CR>
" Swap splits positions.
nmap <M-x> <C-w>x
" Move splits.
nmap <M-y> <C-w><S-h>
nmap <M-c> <C-w><S-k>
nmap <M-S-y> <C-w><S-l>
nmap <M-S-c> <C-w><S-j>

" Move a whole line in normal mode.
nnoremap <C-M-k> :m .-2<CR>==
nnoremap <C-M-j> :m .+1<CR>==
" Move multipe lines at once in visual mode.
vnoremap <C-M-k> :m '<-2<CR>gv=gv
vnoremap <C-M-j> :m '>+1<CR>gv=gv

" Toggle neoterm terminal with Ctrl+T.
map  <C-t> :Ttoggle <CR>
tmap <C-t> exit <CR>

" Make <Enter> key select the highlighted menu item when the popup menu is visible.
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Remove last search highlighting with Escape.
nnoremap <silent><esc> :noh<return><esc>

" Keep selection after indenting in visual mode.
vmap < <gv
vmap > >gv

" Prevent selecting and pasting from overwriting what you originally copied.
xnoremap p pgvy

" Keep cursor at the bottom of the visual selection after you yank it.
vmap y ygv<Esc>

