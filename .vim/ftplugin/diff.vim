"
" Sets up a bunch of keyboard mappings which can help with manually reviewing unified diff files.
" Run :StartReview to set it up. The diff file will be modified by prepending a legend, hunks which are
" reviewed are prepended with X or R
"

command! StartReview call s:StartReview()

" Whether the currently selected location needs updating
let s:UpdatePending = 0

let s:LocationsStatusLine = 'Files to be reviewed %=%l/%L %P'

function! s:StartReview()
    normal gg
    let firstline = getline(1)
    " Insert legend explaining meaning of prefixes
"    if ! (firstline ==? 'Legend')
"        normal OLegend<CR>X diff -- Reviewed file<CR>R diff -- Reviewed file with reject comments<CR>
"    endif

    " Earlier search-based reviewing
    nnoremap <buffer> gn n
    nnoremap <buffer> gN N
"    nnoremap n :let @/='^diff --'<CR>nmzzt
"    nnoremap N :let @/='^diff --'<CR>Nmzzt
"    nmap x 'zgIX n
"    nmap r 'zgIX o
"    nmap w 'zzt

    " Setup folding and collapse everything
    setlocal foldexpr=GetDiffFold(v:lnum)
    setlocal foldmethod=expr
    normal zM

    " Fill location list and modify line's text to be a fancier display
    let diffwin = winnr()
    let diffbuffnr = bufnr(".")
    lvimgrep /diff --git/ %
    let locations = getloclist(diffwin)
    for i in locations
        let i.text = s:BuildLocationLine(diffbuffnr, i)
    endfor
    call setloclist(diffwin, locations)

    " Change title and status line (column is not useful, instead print current line and number of lines)
    "let w:quickfix_title='Modified files'
    call setloclist(diffwin, [], 'a', {'title': 'Modified files', 'context': 'diff-review-plugin'})
    lopen
    let &l:statusline = s:LocationsStatusLine
    " Make sure that pressing Enter in location list "focuses" on that file
    nnoremap <buffer> <CR> <CR>zozt

    " Return to editor
    wincmd p

    " Use gitk keyboard mappings for next / previous file, or scroll up / down
    nnoremap <buffer> f :call <sid>MoveNext()<CR>
    nnoremap <buffer> b :call <sid>MovePrevious()<CR>
    nnoremap <buffer> <space> <C-D>
    nnoremap <buffer> <S-space> <C-U>
    nnoremap <buffer> <BS>    <C-U>

    nnoremap <buffer> x :call <sid>MarkReviewed()<CR>
    nnoremap <buffer> r :call <sid>MarkRejected()<CR>
    nnoremap <buffer> <CR> :call <sid>MoveCurrent()<CR>

    " Undo / redo should update location list on next file move
    nnoremap <buffer> u :call <sid>InvalidateCurrentLocation()<CR>u
    nnoremap <buffer> <C-r> :call <sid>InvalidateCurrentLocation()<CR><C-r>

    " Focus first hunk
    call <sid>MoveCurrent()
endfunction

function! GetDiffFold(lnum)
    if getline(a:lnum) =~? '\v^(. )?diff --'
        return '>1'
    endif

    return '1'
endfunction

function! <sid>InvalidateCurrentLocation()
    let s:UpdatePending = 1
endfunction

function! <sid>MoveNext()
    call s:CheckPendingUpdateLocation()
    " Check for end of file
    let diffwin = win_getid()
    let locationinfo = getloclist(diffwin, {'idx': 0, 'size': 0})
    if locationinfo.idx == locationinfo.size
        echohl ErrorMsg | echo "No next file to review" | echohl None
        return
    endif

    normal! zM
    lnext
    normal! zo
    normal! zt
endfunction

function! <sid>MovePrevious()
    call s:CheckPendingUpdateLocation()
    " Check for beginning of file
    let diffwin = win_getid()
    let locationinfo = getloclist(diffwin, {'idx': 0})
    if locationinfo.idx == 1
        echohl ErrorMsg | echo  "No previous file to review" | echohl None
        return
    endif

    normal! zM
    lprev
    normal! zo
    normal! zt
endfunction

" Moves to currently selected file but without collapsing folds - handy to jump back and forth
function! <sid>MoveCurrent()
    call s:CheckPendingUpdateLocation()
    ll
    normal! zo
    normal! zt
endfunction

function! <sid>MarkReviewed()
    ll
    " Remove any previous Rejection text and mark (after confirmation)
    if getline(".") =~? '\v^R diff --'
        let choice = confirm("File was previously rejected. Do you want to delete any comments and mark as reviewed?", "&Yes\n&No")
        if (choice == 0) || (choice == 2)
            return
        else
            normal! 02x
            let currentLine = line(".")
            let startcommentLine = search('\v\c^index ')
            let lastcommentLine = search('\v^--- ')
            if (startcommentLine != 0 && lastcommentLine != 0 && (lastcommentLine - 1) > startcommentLine)
                " This doesn't work? Instead use start line + number of lines to delete
                "let deleteCommand = (startcommentLine + 1) . "," . (lastcommentLine -1) . "delete"
                let deleteCommand = (startcommentLine + 1) . "delete " . (lastcommentLine - startcommentLine - 1)
                "echom deleteCommand
                execute deleteCommand
            endif
            call cursor(currentLine, 1)
        endif
    endif
    " Do not mark line twice
    if getline(".") =~? '\v^diff --'
        normal! gIX 
    endif
    call s:UpdateCurrentLocation()
    call <sid>MoveNext()
endfunction

function! <sid>MarkRejected()
    "nmap <buffer> r :ll<CR>gIR o
    ll
    " Remove any previous 'Reviewed' mark (after confirmation)
    if getline(".") =~? '\v^X diff --'
        let choice = confirm("File was previously accepted. Do you want to reject it?", "&Yes\n&No")
        if (choice == 0) || (choice == 2)
            return
        else
            normal! 02x
        endif
    endif
    " Do not mark line twice
    if getline(".") =~? '\v^diff --'
        normal! gIR 
    endif
    call <sid>InvalidateCurrentLocation()
    let startofdiffLine = search('\v^--- ')
    if startofdiffLine != 0
        call cursor(startofdiffLine, 1)
        normal! O
        " The 'normal' command will reset mode. Do it again
        startinsert
    endif
endfunction

" Helper method which calculates the location text
function! s:BuildLocationLine(diffbuffnr,item)
    " Find text on line
    let locationline = ''
    let diffline = (getbufline(a:diffbuffnr, a:item.lnum))[0]
    if diffline =~? '\v^X diff --'
        let locationline .= '[X] '
    elseif diffline =~? '\v^R diff --'
        let locationline .= '[R] '
    else
        let locationline .= '[ ] '
    endif
    let changedfilenamepos = stridx(diffline, ' b/')
    " Substring the target filename without b/ prefix
    let changedfilename = strpart(diffline, changedfilenamepos + 3)
    return locationline . changedfilename
endfunction

" Updates the [X] or [R] box in the location list
function! s:UpdateCurrentLocation()
    let diffwin = win_getid()
    "echom diffwin
    let diffbuffnr = bufnr(".")
    let locations = getloclist(diffwin)
    let locationinfo = getloclist(diffwin, {'idx': 0, 'winid': 0})
    "echom string(locationinfo)
    let idx = locationinfo.idx - 1
    let locations[idx].text = s:BuildLocationLine(diffbuffnr, locations[idx])

    " Jump to location list window to save its position, then jump back to selected item.
    call win_gotoid(locationinfo.winid)
    let windowpos = winsaveview()
    call setloclist(diffwin, [], 'r', {'items': locations, 'title': 'Modified files', 'context': 'diff-review-plugin'})
    " Fails on (old) Vim 8.1
    "call setloclist(diffwin, [], 'a', {'idx': idx})
    execute 'll! ' . (idx + 1)

    " Restore view position and force our own statusline config
    call win_gotoid(locationinfo.winid)
    call winrestview(windowpos)
    let &l:statusline = s:LocationsStatusLine
    call win_gotoid(diffwin)
endfunction

function! s:CheckPendingUpdateLocation()
    if s:UpdatePending == 1
        call s:UpdateCurrentLocation()
    endif
    let s:UpdatePending = 0
endfunction
