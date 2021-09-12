" Buffer viewer key binds.
"
" A special check is made to switch focus away from the NERDTree.
" Otherwise such a buffer viewer would trigger inside the tree buffer and
" treat its vertical "magic view" as a regular window split.

nnoremap \bv :call NavigateBE('down', 'BufExplorerVerticalSplit')<CR>
nnoremap \bs :call NavigateBE('down', 'BufExplorerHorizontalSplit')<CR>
nnoremap \be :call NavigateBE('down', 'BufExplorer')<CR>

let g:bufExplorerShowRelativePath=1
" Only show buffers which have been opened in the current tab.
"let g:bufExplorerShowTabBuffer=1

function! NavigateBE(direction,cmd)
    " Navigate away from NERDTree, we shouldn't replace its magic pane with BE
    if exists("b:NERDTree")
        wincmd p
    endif
    " Previous window can be closed so we cannot return to to it. Let user take action.
    if exists("b:NERDTree")
        echohl ErrorMsg | echom "Focus is stuck on NERDTree" | echohl None
        return
    endif
    if (a:direction ==# 'down' && bufname('%') !=# '[BufExplorer]')
        " Run BufExplorer cmd.
        execute a:cmd
        " Don't select the first file.
        normal j
    elseif (a:direction ==# 'down' && bufname('%') ==# '[BufExplorer]')
        " Start from first buffer again.
        if (line('.') ==# line('$'))
            call cursor(1,1)
            let firstline = search('^[^"]')
            call cursor(firstline, 1)
            normal w
        else
            normal j
        endif
    elseif (a:direction ==# 'up' && bufname('%') !=# '[BufExplorer]')
        " Run BufExplorer cmd.
        execute a:cmd
        " Go to last buffer.
        normal G
    elseif (a:direction ==# 'up' && bufname('%') ==# '[BufExplorer]')
        normal k
        " We scrolled into the comments at the top. Go to end.
        if (match(getline('.'), '^"') !=# -1)
            normal G
        endif
    endif
endfunction
