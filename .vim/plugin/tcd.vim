"let g:tcd_plugin_debug=1

command! -nargs=? Tcd call SetTCD(<args>)
" Personal preference: typing :TCD simply means holding the shift key.
command! -nargs=? TCD call SetTCD(<args>)

" Set local current directory for all windows in the current tab to get
" a tab-local current directory.
" Expects one optional argument, a path. If not given, use the path of the
" current file.
function! SetTCD(...)
    let win_count = winnr('$')
    let win_focus = winnr()
    if (a:0 ==# 0)
        let pathStr = expand('%:p:h')
    else
        let pathStr = expand(a:1)
    endif
    let i = 1
    call s:DebugLog("Updating lcd to " . fnameescape(pathStr) . " for " . win_count . " windows")
    try
        " Don't trigger any change events
        set eventignore=all
        while (i <= win_count)
            execute i . "wincmd w"
            execute "lcd" fnameescape(pathStr)
            let i += 1
        endwhile
        execute win_focus . "wincmd w"
        call s:DebugLog("Updated all windows")
    finally
        set eventignore=
    endtry
endfunction

function! s:DebugLog(text)
    if exists("g:tcd_plugin_debug")
        echomsg a:text
    endif
endfunction

"""
" NERDTree Integration / hack
"""

" Use delayed call so that user has the oportunity to set g:TCDUsedInNERDTree
autocmd VimEnter * call s:CheckNERDTreeInject()

function! s:CheckNERDTreeInject()
    if (exists("g:TCDUsedInNERDTree") && exists("*NERDTreeAddKeyMap") && g:TCDUsedInNERDTree ==# 1)
        " Override changeToDir() method to use TCD plugin.
        function! g:NERDTreePath.changeToDir() dict
            let dir = self.str({'format': 'Cd'})
            if self.isDirectory ==# 0
                let dir = self.getParent().str({'format': 'Cd'})
            endif

            try
                call SetTCD(dir)
                call nerdtree#echo("Tab CWD is now: " . getcwd())
            catch
                throw "NERDTree.PathChangeError: cannot change Tab CWD to " . dir
            endtry
        endfunction

    elseif (exists("g:TCDUsedInNERDTree") && ! exists("*NERDTreeAddKeyMap"))
        echohl Error
        echomsg "Cannot integrate TCD with NERDTree, NERDTree is not installed!"
        echohl NONE
    endif
endfunction
