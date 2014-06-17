" Bind <C-S> to save in all relevant modes.
nnoremap <C-S> :w<CR>
inoremap <C-S> <C-O>:w<CR>

" Shortcuts for Eclipse
nnoremap <C-F6> :call NavigateBE('down', 'BufExplorer')<CR>
inoremap <C-F6> <C-O>:call NavigateBE('down', 'BufExplorer')<CR>
nnoremap <C-S-F6> :call NavigateBE('up', 'BufExplorer')<CR>
inoremap <C-S-F6> <C-O>:call NavigateBE('up', 'BufExplorer')<CR>
