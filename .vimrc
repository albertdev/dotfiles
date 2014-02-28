"We can do without mswin...
"source $VIMRUNTIME/mswin.vim

"set clipboard=unnamed
set showtabline=2 " Always show tabs
set selectmode=
set keymodel=
set tabstop=4
set shiftwidth=4
set softtabstop=4
set autoindent
set ffs=dos,unix
set nowrap
set showbreak=->\ \|
set expandtab
set listchars=eol:$,tab:»\ ,trail:.,nbsp:·
set ignorecase
set wildmode=longest:list

" End of line marker
"set colorcolumn=101
hi ColorColumn ctermbg=lightgrey guibg=lightgrey

" Fonts settings   
" For has() use, see http://superuser.com/questions/193250/how-can-i-distinguish-current-operating-system-in-my-vimrc
if has("mac")
elseif has("unix")
  " do stuff under linux and "
elseif has("win32")
    "set guifont=PixelCarnageMonoTT:h10:cDEFAULT
    "set guifont=ProggyCleanSZ:h8:cDEFAULT
    set guifont=DejaVu_Sans_Mono:h10:cDEFAULT
endif

" backspace and cursor keys wrap to previous/next line
set backspace=indent,eol,start whichwrap+=<,>,[,]

execute pathogen#infect()

syntax on

filetype plugin on

source ~/vimfiles/custom.vim
source ~/vimfiles/statusline.vim

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

