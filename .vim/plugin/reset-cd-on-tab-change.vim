if exists("s:custom_cd_cmds_loaded")
    autocmd! customcdcmds
endif
augroup customcdcmds
    autocmd WinEnter * call CustomCDWinEnter()
    autocmd WinLeave * call CustomCDWinLeave()
    autocmd BufEnter * call CustomCDBufEnter()
    autocmd BufNewFile * call CustomCDBufNewOrRead()
    autocmd BufReadPost * call CustomCDBufNewOrRead()
    autocmd BufLeave * call CustomCDBufLeave()
    autocmd TabEnter * echomsg "Entered tab" tabpagenr()
    autocmd TabLeave * echomsg "Left Tab" tabpagenr()
augroup END
let s:custom_cd_cmds_loaded=1

"Note
let s:previous_tab=-1
let s:previous_window=-1

function! s:getcwd()
    return getcwd()
endfunction

function! CustomCDWinEnter()
    echomsg "Entered window" tabpagenr() . ':' . winnr() "from" s:previous_tab . ':' . s:previous_window 'with buf' expand('<abuf>')
    echomsg "Current dir" s:getcwd()
endfunction

function! CustomCDWinLeave()
    echomsg "Left window" tabpagenr() . ':' . tabpagewinnr(tabpagenr()) 'with buf' expand('<abuf>')
    echomsg "Current dir" s:getcwd()
    let s:previous_tab=tabpagenr()
    let s:previous_window=winnr()
    let t:saved_cd=getcwd()
endfunction

function! CustomCDBufEnter()
    echomsg "Entered Buffer" expand('<abuf>') '|' bufnr('%') ": '" . expand('%:p') . "' | '" . expand('<afile>:p') . "'"
    if s:previous_tab != -1 && s:previous_tab != tabpagenr()
        echomsg "#Different tab"
        if expand('<afile>') == ''
            "echomsg "!Ignored"
            cd ~/
            echomsg "Current dir (empty buffer)" s:getcwd()
        elseif exists("t:saved_cd")
            execute 'cd' fnameescape(t:saved_cd)
            echomsg "Current dir (restored)" s:getcwd()
            let s:previous_tab=-1
            let s:previous_window=-1
        else
            "Fresh tab, use current file path
            cd %:p:h
            echomsg "Current dir (new tab)" s:getcwd()
            let s:previous_tab=-1
            let s:previous_window=-1
        endif
    elseif s:previous_tab != -1 && s:previous_window != winnr()
        echomsg "#Different window, same tab"
    endif
"    if expand('%') == '' && winnr("$") == 1 && ! exists("b:NERDTreeType")
"        cd ~/
"        echomsg "Blank tab? Reset to" getcwd()
"        let t:init_cd_set=1
"    elseif ! exists("t:init_cd_set")
"        "|| ! exists("t:saved_cd")
"        let t:init_cd_set=1
"        cd <afile>:p:h
"        let t:saved_cd=getcwd()
"        echomsg "New tab? Stored" t:saved_cd
"    elseif exists("t:saved_cd")
"        execute 'cd' t:saved_cd
"        "let t:saved_cd=getcwd()
"        echomsg "Existing tab? Stored" t:saved_cd
"    else
"        echomsg "Nothing to do here..."
"    endif
endfunction
"
function! CustomCDBufNewOrRead()
    echomsg "Read into Buffer" expand('<abuf>') '|' bufnr('%') ':'  expand('%:p') "|" expand('<afile>:p')
    echomsg "Current dir" getcwd()
"    echomsg "Read into Buffer" expand('%:p') "also known as" expand('<afile>:p')
"    if ! exists("t:init_cd_set")
"        let t:init_cd_set=1
"        execute 'cd' expand('<afile>:p:h')
"        let t:saved_cd=getcwd()
"        echomsg "New buffer, stored" t:saved_cd
"    else
"        echomsg "New buffer, in initialized tab?"
"    endif
endfunction
"
function! CustomCDBufLeave()
"    let t:saved_cd=getcwd()
"    echomsg "Left Buf and stored " t:saved_cd
    echomsg "Left buffer" expand('<abuf>') '|' bufnr('%') '@' tabpagenr() . ':' . tabpagewinnr(tabpagenr())
    echomsg "Current dir" getcwd()
    "NERDTree creates a new empty buffer in a new tab, which is then replaced
    "with a new one. Don't update numbers.
    "let s:previous_tab=tabpagenr()
    "let s:previous_window=winnr()
endfunction
"
"function! CustomCDTabLeave()
"    let t:saved_cd=getcwd()
"    echomsg "Left Tab" tabpagenr() "and stored " t:saved_cd
"endfunction
