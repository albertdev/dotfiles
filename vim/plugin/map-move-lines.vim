" From wikia's Vim tip 646
" http://vim.wikia.com/wiki/Moving_lines_up_or_down#Mappings_to_move_lines
" Alt + cursor keys allow to move lines of text, or blocks when in V mode

nnoremap <M-Down> :m+<CR>
inoremap <M-Down> <Esc>:m+<CR>gi

nnoremap <M-Up> :m-2<CR>
inoremap <M-Up> <Esc>:m-2<CR>gi

" Use Damian Conway's dragvisuals script for visual modes
vmap  <expr>  <M-Left>   DVB_Drag('left') 
vmap  <expr>  <M-Right>  DVB_Drag('right')
vmap  <expr>  <M-Down>   DVB_Drag('down') 
vmap  <expr>  <M-Up>     DVB_Drag('up')   
