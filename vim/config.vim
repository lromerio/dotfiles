"###################################################
"# => General vim configuration (no plugin needed)
"###################################################

set timeout
set timeoutlen=750
set ttimeoutlen=250
if has('nvim')
    set ttimeout
    set ttimeoutlen=0
endif
if $TERM == 'alacritty'
    set ttymouse=sgr
endif

" Set column border
set cc=80
" Use system clipboard
set clipboard=unnamedplus
" Spell check
set spell spelllang=en_us

" Sets how many lines of history VIM has to remember
set history=1000

" Hide mouse after chars typed
set mousehide
" enbable the mouse in term
set mouse=a

" Set a dolar at the end of the word when changing that word
set cpoptions+=$

" Faster keywork completion
set complete-=i   " disable scanning included files
set complete-=t   " disable searching tags

" Writes on make/shell commands
set autowrite

" Add extra characters that are valid parts of variables
set iskeyword+=\$,-

" Keep three lines below the last line when scrolling
set scrolloff=3

" Make vim completion popup menu work like in an IDE
set completeopt=menuone,longest,preview

" Show some line numbers the nice way
set number

" Automatically reload changes if detected
set autoread

" code folding; using 3 open/closing braces
" http://vim.wikia.com/wiki/Folding
set foldmethod=marker

" Enable paste mode
set pastetoggle=<F3>

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","

" Hide the mouse pointer while typing
set mousehide

" Show the current mode
set showmode

" When completing by tag, show the whole tag, not just the function name
set showfulltag

" Add ignorance of whitespace to diff
set diffopt+=iwhite

"###################################################
"# => VIM UI
"###################################################

" Show cursorline
set cul

" Make the command area two lines high
set cmdheight=2

" Set the title of the window in the terminal to the file
set title

" Show invisible caracters
set list
if &listchars ==# 'eol:$'
  set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
endif

" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

" Turn on the WiLd menu
set wildmenu

" Ignore compiled files
set wildignore=*~,.svn,CVS,.git,.hg,*.o,*.a,*.class,*.mo,*.la,
    \*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,
    \*.gif,.DS_Store,*.aux,*.out,*.toc,*.tmp,*.pyc,*.cabal-sandbox,
    \*.swo

"Always show current position
set ruler

" A buffer becomes hidden when it is abandoned
set hid

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Ignore case when searching
set ignorecase
" When searching try to be smart about cases
set smartcase
" Highlight search results
set hlsearch
" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch

" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

"#######################
"# => Colors and Fonts
"#######################

" Enable syntax highlighting
syntax enable

" Enable terminal colors if possible
if $TERM =~ "-256color"
    set t_Co=256
endif

colorscheme gruvbox
set background=dark

" change highlight color
hi Visual guifg=Black guibg=LightGreen gui=none

" set extra options when running in GUI mode
if has("gui_running")
    set guioptions-=T
    " Disable scrollbars (real hackers don't use scrollbars for navigation!)
    set guioptions-=r
    set guioptions-=R
    set guioptions-=l
    set guioptions-=L
    set guioptions+=e

    " windows colors correction
    set t_Co=256
    set term=xterm
    let &t_AB="\e[48;5;%dm"
    let &t_AF="\e[38;5;%dm"

    set guitablabel=%M\ %t
    set lines=50 columns=160

    if has("win32")
        set gfn=Liberation\ Mono:h10
    endif

    if has("unix")
        " set gfn=Ubuntu\ Mono\ derivative\ Powerline\ 11
        set gfn=Source\ Code\ Pro\ for\ Powerline\ Regular\ 10
    endif

    colorscheme gruvbox
    set background=dark
    hi Visual guifg=Black guibg=LightGreen gui=none
endif

" Set utf8 as standard encoding
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac

"#############################
"# => Files, backups and undo
"#############################

" Turn backup off
set nobackup
set nowb
set noswapfile

"##################################
"# => Text, tab and indent related
"##################################

" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set softtabstop=4
set tabstop=4

" Linebreak on 500 characters
set lbr
set tw=500

" Auto indent
set ai

" Smart indent
set si

" Wrap lines
set wrap

" Remember info about open buffers on close
set viminfo^=%

"###################
"# => Status line
"###################

" Always show the status line
set laststatus=2

" Turn off some vim logging stuff to .viminfo
set viminfo=<0,'100,<50,s10,h

"#############################
"# => Plugins configurations
"#############################

let g:airline_theme="gruvbox"
let g:airline_detect_modified=1
let g:airline_detect_paste=1
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#hunks#enabled = 1
let g:airline#extensions#hunks#hunk_symbols = ['+', '~', '-']
let g:airline#extensions#hunks#non_zero_only = 0
let g:airline#extensions#syntastic#enabled = 1
let g:airline#extensions#virtualenv#enabled = 1
let g:airline#extensions#tagbar#enabled = 1

let g:deoplete#enable_at_startup = 1
