"let g:NERDTreeQuitOnOpen=1

let g:TCDUsedInNERDTree=1

" Close the current tab or editor if only the NERDTree window remains
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" Eclipse mapping
nnoremap <C-A-Left> :<C-U>NERDTreeFind<CR>

" Finds current file and stays in tree, no matter how many times pressed.
nnoremap <Leader>nf :<C-U>NERDTreeFind<CR>

" Directly switches focus to NERDTree without selecting current file.
" Slightly faster <C-W>p / w when lots of windows are open.
nnoremap <Leader>ng :<C-U>NERDTreeFocus<CR>

" Finds current file and immediately returns focus to window.
nnoremap <Leader>no :<C-U>NERDTreeFind<CR><C-W>p

" Vanilla toggle action
nnoremap <Leader>nt :<C-U>call CustomNERDTreeToggle()<CR>

" Override search mapping in easymotion, this switches between windows.
nnoremap <Leader>n <C-W>p

" Allows us to close the NERDTree from anywhere, yet find the current file if it wasn't
" open anymore.
function! CustomNERDTreeToggle()
    if g:NERDTree.IsOpen()
        call g:NERDTree.Close()
    else
        NERDTreeFind
    endif
endfunction
