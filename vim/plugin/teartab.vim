"let g:teartab_plugin_debug=1

command! Teartab call s:TearTab()
command! TT call s:TearTab()

" Moves the current buffer to a new tab and reloads the buffer.
" The window where the buffer was will display the alternate buffer instead.
function! s:TearTab()
    let win_focus = winnr()
    let tab_focus = tabpagenr()
    let curbuf = bufnr('%')
    let altbuf = bufnr('#')
    let nrbufs = bufnr('$')
    call s:DebugLog( "Current buffer:" . curbuf . ", alt buffer:" . altbuf )
    try
        set eventignore=all

        tab split
        let newtab = tabpagenr()
        if (altbuf == -1 || nrbufs == 1)
            " Special case: there is no alternate buffer, only do the split
            " Only go back to old tab page to trigger tab leave / enter again.
            execute "tabnext" tab_focus
            call s:DebugLog( "Single buffer, did a split" )
        else
            execute "tabnext" tab_focus
            execute "buffer" altbuf
            call s:DebugLog( "Switched to alt buffer " . altbuf . " in " . tab_focus . ':' . win_focus )
        endif
    finally
        set eventignore=
    endtry
    call s:DebugLog( "Switching to teared tab " . newtab )
    execute "tabnext" newtab
    " This should be enough to trigger the auto-tcd plugin
    doautocmd BufReadPost
endfunction

function! s:DebugLog(text)
    if exists("g:teartab_plugin_debug")
        echomsg a:text
    endif
endfunction
