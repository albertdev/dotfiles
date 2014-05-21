"let g:NERDTreeQuitOnOpen=1

" Close the current tab or editor if only the NERDTree window remains
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" Eclipse mapping
nnoremap <C-A-Left> :<C-U>NERDTreeFind<CR>
nnoremap \nf :<C-U>NERDTreeFind<CR>
"Finds current file and immediately returns focus to window.
nnoremap \no :<C-U>NERDTreeFind<CR><C-W>p
nnoremap \nt :<C-U>call CustomNERDTreeToggle()<CR>
"Override mapping in easymotion, switches between windows.
nnoremap \n <C-W>p

" Allows us to toggle the NERDTree, yet find the current file if it wasn't
" open anymore.
function! CustomNERDTreeToggle()
    if nerdtree#isTreeOpen()
        NERDTreeToggle
    else
        NERDTreeFind
    endif
endfunction
