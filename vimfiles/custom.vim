nnoremap <C-n> h
xnoremap <C-n> h
onoremap <C-n> h
nnoremap <C-u> gk
xnoremap <C-u> gk
onoremap <C-u> gk
nnoremap <C-e> gj
xnoremap <C-e> gj
onoremap <C-e> gj
nnoremap <C-i> l
xnoremap <C-i> l
onoremap <C-i> l
inoremap <C-n> <Left>
"cnoremap <C-n> <Left>
inoremap <C-u> <C-o>gk
"cnoremap <C-u> <Up>
inoremap <C-e> <C-o>gj
"cnoremap <C-e> <Down>
inoremap <C-i> <Right>
"cnoremap <C-i> <Right>

" Fix Alt+Space problem
map <M-Space> :simalt ~<CR>

" Alt + cursor keys allow to move lines of text, or blocks when in V mode
" The '==' commands re-indent the selected line or block.
"nnoremap <M-Down> :m+<CR>==
"inoremap <M-Down> <Esc>:m+<CR>==gi
"vnoremap <M-Down> :m'>+<CR>gv=gv

"nnoremap <M-Up> :m-2<CR>==
"inoremap <M-Up> <Esc>:m-2<CR>==gi
"vnoremap <M-Up> :m-2<CR>gv=gv

"Versions without auto-indent
nnoremap <M-Down> :m+<CR>
inoremap <M-Down> <Esc>:m+<CR>gi
vnoremap <M-Down> :m'>+<CR>gvgv

nnoremap <M-Up> :m-2<CR>
inoremap <M-Up> <Esc>:m-2<CR>gi
vnoremap <M-Up> :m-2<CR>gvgv

