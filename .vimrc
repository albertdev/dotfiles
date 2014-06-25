" Cargo cult programming to ward of vi spirits.
set nocompatible
" Required by Vundle initialization
filetype off
" 'listchars' uses UTF-8
scriptencoding utf-8

" On Windows, also use '.vim' instead of 'vimfiles'; this makes synchronization
" across (heterogeneous) systems easier.
if has('win32') || has('win64')
    set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
endif

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
" alternatively, pass a path where Vundle should install bundles
"let path = '~/some/path/here'
"call vundle#rc(path)

" let Vundle manage Vundle, required
Bundle 'gmarik/vundle'

" Vundle-managed bundles.
" scripts from github
"Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-sensible'
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-sensible'
Bundle 'tpope/vim-surround'
Bundle 'sukima/xmledit'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'tommcdo/vim-exchange'
Bundle 'scrooloose/nerdtree'
Bundle 'jlanzarotta/bufexplorer'
Bundle 'moll/vim-bbye'
Bundle 'vim-scripts/cecutil'
Bundle 'vim-scripts/vis'
Bundle 'dagwieers/asciidoc-vim'

" Load everything upon enabling filetype loading.
" Required by Vundle
filetype plugin indent on

"set clipboard=unnamed
set showtabline=2 " Always show tabs
set selectmode=   " Never use selectmode. Visual is enough.
set keymodel=     " Doesn't make sense since we don't want selectmode
set tabstop=4
set shiftwidth=4
set softtabstop=4
set autoindent
set ffs=dos,unix  " Windows is too much used to write unix LE everywhere.
set nowrap
set showbreak=->\ \| " When wrap _is_ enabled, do it in style.
set expandtab
set listchars=eol:$,tab:»\ ,trail:.,nbsp:∙
set ignorecase
set wildmode=longest:list " Default zsh-style completion
let maplocalleader = "|"
set encoding=utf-8
set hlsearch

" End of line marker position and color
"set colorcolumn=101
hi ColorColumn ctermbg=lightgrey guibg=lightgrey

" Fonts settings   
if has("mac")
elseif has("unix")
    " unix might use DejaVu by default.
elseif has("win32")
    "set guifont=PixelCarnageMonoTT:h10:cDEFAULT
    "set guifont=ProggyCleanSZ:h8:cDEFAULT
    set guifont=DejaVu_Sans_Mono:h10:cDEFAULT
endif

" backspace and cursor keys wrap to previous/next line
set backspace=indent,eol,start whichwrap+=<,>,[,]

syntax on

"if has("gui_running")
"  " GUI is running or is about to start.
"  " Maximize gvim window.
"  set lines=99999 columns=99999
"else
"  " This is console Vim.
"  if exists("+lines")
"    set lines=50
"  endif
"  if exists("+columns")
"    set columns=100
"  endif
"endif

" Maximize Vim on startup.
"au GUIEnter * simalt ~x

" Alt-Space is System menu
"if has("gui")
  "noremap <M-Space> :simalt ~<CR>
  "inoremap <M-Space> <C-O>:simalt ~<CR>
  "cnoremap <M-Space> <C-C>:simalt ~<CR>
"endif

"Change highlighting for "Ignore" group.
hi Ignore ctermfg=Gray guifg=Gray

