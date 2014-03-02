" From wikia's Vim tip 646
" http://vim.wikia.com/wiki/Moving_lines_up_or_down#Mappings_to_move_lines
" Alt + cursor keys allow to move lines of text, or blocks when in V mode
" The '==' commands re-indent the selected line or block.
"nnoremap <M-Down> :m+<CR>==
"inoremap <M-Down> <Esc>:m+<CR>==gi
"vnoremap <M-Down> :m'>+<CR>gv=gv

"nnoremap <M-Up> :m-2<CR>==
"inoremap <M-Up> <Esc>:m-2<CR>==gi
"vnoremap <M-Up> :m-2<CR>gv=gv

" A version without auto-indent
nnoremap <M-Down> :m+<CR>
inoremap <M-Down> <Esc>:m+<CR>gi
vnoremap <M-Down> :m'>+<CR>gvgv

nnoremap <M-Up> :m-2<CR>
inoremap <M-Up> <Esc>:m-2<CR>gi
vnoremap <M-Up> :m-2<CR>gvgv


