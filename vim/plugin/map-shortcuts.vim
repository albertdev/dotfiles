" Bind <C-S> to save in all relevant modes.
nnoremap <C-S> :w<CR>
inoremap <C-S> <C-O>:w<CR>

" Shortcuts for Eclipse
nnoremap <C-F6> :call NavigateBE('down', 'BufExplorer')<CR>
inoremap <C-F6> <C-O>:call NavigateBE('down', 'BufExplorer')<CR>
nnoremap <C-S-F6> :call NavigateBE('up', 'BufExplorer')<CR>
inoremap <C-S-F6> <C-O>:call NavigateBE('up', 'BufExplorer')<CR>
" Shortcuts for Visual Studio
nnoremap <C-Tab> :call NavigateBE('down', 'BufExplorer')<CR>
inoremap <C-Tab> <C-O>:call NavigateBE('down', 'BufExplorer')<CR>
nnoremap <C-S-Tab> :call NavigateBE('up', 'BufExplorer')<CR>
inoremap <C-S-Tab> <C-O>:call NavigateBE('up', 'BufExplorer')<CR>

" Duplicate current selection
vmap  <expr>  D        DVB_Duplicate()

" Toggle between inclusive and exclusive selection
nnoremap <F4> :<C-U>call UserToggleSelection()<CR>
vnoremap <F4> :<C-U>call UserToggleSelection()<CR>gv

" Toggle concealing on or off.
nnoremap <C-S-F8> :call UserToggleConcealing()<CR>
inoremap <C-S-F8> <C-O>:call UserToggleConcealing()<CR>
vnoremap <C-S-F8> :<C-U>call UserToggleConcealing()<CR>gv

" Oddly, Vi back in the day treated it like yy. Make it more consistent.
nnoremap Y y$

" Ctrl-V is used for paste in most editors. Use Shift-F8 for visual block mode.
noremap <S-F8> <C-V>

" Eclipse previous / next position shortcuts
nnoremap <silent> <M-Left>      <C-O>
nnoremap <silent> <M-Right>     <C-I>
inoremap         <M-Left>  <C-O><C-O>
inoremap         <M-Right> <C-O><C-I>
