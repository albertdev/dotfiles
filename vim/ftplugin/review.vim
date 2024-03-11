"
" Sets up a bunch of keyboard mappings to review specially prepared unified diff files.
" Diff hunks which are reviewed are prepended with X or R.
"

" Lines taken from Vim dist's ftplugin/diff.vim
if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

let b:undo_ftplugin = "setl modeline<"

" Don't use modelines in a diff, they apply to the diffed file
setlocal nomodeline 

" End of lines taken from diff ftplugin

syntax enable
set syntax=diff


"command! RestartReview call s:StartReview()

" Trigger the actual logic when Vim is initialized (Vimgrep during ftplugin load seems to do curious things)
call timer_start(200, { tid -> s:StartReview() }, {'repeat':0})

" Whether the currently selected location needs updating
let s:UpdatePending = 0
" Whether Review submode is active and an indicator needs to be printed
let s:ReviewModeActive = 0

let s:ReviewModeTimer = -1

let b:ReviewCommit = ''

let s:LocationsStatusLine = 'Files to be reviewed %=%l/%L %P'

function! s:StartReview()
    normal! gg
    "let firstline = getline(1)

    let reviewCommitLine = search('\v^Commit: ')
    if (reviewCommitLine == 0)
        echohl ErrorMsg | echo "Could not determine source commit" | echohl None
        return
    endif
    let b:ReviewCommit = strpart(getline(reviewCommitLine), 8)

    " Setup folding and collapse everything
    setlocal foldexpr=GetDiffFold(v:lnum)
    setlocal foldmethod=expr
    normal! zM

    " Fill location list and modify line's text to be a fancier display
    let diffwin = winnr()
    let diffbuffnr = bufnr(".")
    keeppatterns lvimgrep /\mdiff --[[:alpha:]]\+/ %
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
    nnoremap <buffer> rf :<C-U>call <sid>MoveNext(v:count1)<CR>
    nnoremap <buffer> rF :<C-U>call <sid>MoveNextUnreviewed()<CR>
    nnoremap <buffer> rb :<C-U>call <sid>MovePrevious(v:count1)<CR>
    nnoremap <buffer> rgg :<C-U>call <sid>MoveFirst()<CR>
    nnoremap <buffer> rG  :<C-U>call <sid>MoveLast()<CR>
    nnoremap <buffer> rd  :<C-U>call <sid>OpenExternalDiff()<CR>
    nnoremap <buffer> <space> <C-D>
    nnoremap <buffer> <S-space> <C-U>
    nnoremap <buffer> <BS>    <C-U>

    nnoremap <buffer> rx :<C-U>call <sid>MarkReviewed()<CR>
    nnoremap <buffer> rr :<C-U>call <sid>MarkRejected()<CR>
    nnoremap <buffer> <CR> :<C-U>call <sid>MoveCurrent()<CR>

    " Undo / redo should update location list on next file move
    nnoremap <buffer> u :<C-U>call <sid>InvalidateCurrentLocation()<CR>u
    nnoremap <buffer> <C-r> :<C-U>call <sid>InvalidateCurrentLocation()<CR><C-r>

    " Bind 'R' to trigger Review mode where the above keys keep working until ESC is pressed
    nnoremap <buffer> R :<C-U>call <sid>EnterReviewMode()<CR>
" Only do this when not done yet for this buffer

    call <sid>MoveFirstUnreviewed()
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

function! <sid>MoveNext(number)
    call s:CheckPendingUpdateLocation()
    " Check for end of file
    let diffwin = win_getid()
    let locationinfo = getloclist(diffwin, {'idx': 0, 'size': 0})
    if locationinfo.idx == locationinfo.size
        echohl ErrorMsg | echo "Cannot jump to next file, end reached" | echohl None
        return
    endif
    let filesDown = min([locationinfo.idx + a:number, locationinfo.size]) - locationinfo.idx

    normal! zM
    execute filesDown 'lnext'
    normal! zo
    normal! zt
endfunction

function! <sid>MovePrevious(number)
    call s:CheckPendingUpdateLocation()
    " Check for beginning of file
    let diffwin = win_getid()
    let locationinfo = getloclist(diffwin, {'idx': 0})
    if locationinfo.idx == 1
        echohl ErrorMsg | echo  "No previous file to review" | echohl None
        return
    endif
    let filesUp = min([locationinfo.idx - 1, a:number])

    normal! zM
    execute filesUp 'lprev'
    normal! zo
    normal! zt
endfunction

" Finds the next diff block down the file which has no 'X' or 'R' marker and jumps to it.
" The first item can never be matched.
function! <sid>MoveNextUnreviewed()
    call s:CheckPendingUpdateLocation()
    " Check for end of file
    let diffwin = win_getid()
    let locationinfo = getloclist(diffwin, {'idx': 0, 'size': 0})
    if locationinfo.idx == locationinfo.size
        echohl ErrorMsg | echo "Cannot jump to next file, end reached" | echohl None
        return
    endif
    let locations = getloclist(diffwin)
    " Move cursor to next line after the start of the currently selected item
    let currentItemStart = locations[locationinfo.idx - 1].lnum
    call cursor(currentItemStart + 1, 1)
    let nextUnreviewedDiff = search('\v^diff --')
    if nextUnreviewedDiff == 0
        echohl ErrorMsg | echo "No next unreviewed file found." | echohl None
        return
    endif
    " Find item in location list corresponding to matched line
    let i = 0
    while i < len(locations) && locations[i].lnum != nextUnreviewedDiff
        let i += 1
    endwhile
    let itemsToMoveDown = i - (locationinfo.idx - 1)
    call <sid>MoveNext(itemsToMoveDown)
endfunction

" Finds the first diff block in the file which has no 'X' or 'R' marker and jumps to it
function! <sid>MoveFirstUnreviewed()
    call cursor(1, 1)
    let nextUnreviewedDiff = search('\v^diff --')
    if nextUnreviewedDiff == 0
        call <sid>MoveCurrent()
        echohl ErrorMsg | echo "Review was completed last time" | echohl None
        return
    endif
    let diffwin = win_getid()
    let locationinfo = getloclist(diffwin, {'idx': 0, 'size': 0})
    let locations = getloclist(diffwin)
    let i = 0
    while i < len(locations) && locations[i].lnum != nextUnreviewedDiff
        let i += 1
    endwhile
    let itemsToMoveDown = i - (locationinfo.idx - 1)
    if (itemsToMoveDown == 0)
        call <sid>MoveCurrent()
    else
        call <sid>MoveNext(itemsToMoveDown)
    endif
endfunction

function! <sid>MoveFirst()
    call s:CheckPendingUpdateLocation()

    normal! zM
    lfirst
    normal! zo
    normal! zt
endfunction

function! <sid>MoveLast()
    call s:CheckPendingUpdateLocation()

    normal! zM
    llast
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
    call <sid>MoveNext(1)
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
    let diffbuffnr = bufnr(".")
    let locations = getloclist(diffwin)
    let locationinfo = getloclist(diffwin, {'idx': 0, 'winid': 0})
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

function! <sid>OpenExternalDiff()
    let diffwin = win_getid()
    let locationinfo = getloclist(diffwin, {'idx': 0})
    let locations = getloclist(diffwin)
    " Line number where currently selected diff starts
    let linenumber = locations[locationinfo.idx - 1].lnum

    let diffline = getline(linenumber)
    let changedfilenamepos = stridx(diffline, ' b/')
    " Substring the target filename without b/ prefix
    let changedfilename = strpart(diffline, changedfilenamepos + 3)
    "execute 'silent !git difftool -g -y ' . b:ReviewCommit . '^ ' . b:ReviewCommit . ' -- :/' . changedfilename
    let difftoolcommand = 'silent !git difftool -g -y "' . b:ReviewCommit . '^" ' . b:ReviewCommit . ' -- ":/' . changedfilename . '"'
    execute difftoolcommand
endfunction

function! <sid>EnterReviewMode()
    nnoremap <buffer> f :<C-U>call <sid>MoveNext(v:count1)<CR>
    nnoremap <buffer> F :<C-U>call <sid>MoveNextUnreviewed()<CR>
    nnoremap <buffer> b :<C-U>call <sid>MovePrevious(v:count1)<CR>
    nnoremap <buffer> x :<C-U>call <sid>MarkReviewed()<CR>
    nnoremap <buffer> r :<C-U>call <sid>MarkRejected()<CR>
    nnoremap <buffer> gg :<C-U>call <sid>MoveFirst()<CR>
    nnoremap <buffer> G  :<C-U>call <sid>MoveLast()<CR>
    nnoremap <buffer> d  :<C-U>call <sid>OpenExternalDiff()<CR>
    nnoremap <buffer> <ESC> :<C-U>call <sid>ExitReviewMode()<CR><ESC>
    let s:ReviewModeActive = 1
    if (s:ReviewModeTimer != -1) 
        call timer_stop(s:ReviewModeTimer)
    endif
    let s:ReviewModeTimer = timer_start(1000, { tid -> s:PrintReviewModeInStatusLine() }, { 'repeat': -1 })
endfunction

function! <sid>ExitReviewMode()
    silent! nunmap <buffer> f
    silent! nunmap <buffer> F
    silent! nunmap <buffer> b
    silent! nunmap <buffer> x
    silent! nunmap <buffer> r
    silent! nunmap <buffer> gg
    silent! nunmap <buffer> G
    silent! nunmap <buffer> d
    let s:ReviewModeActive = 0
    if (s:ReviewModeTimer != -1) 
        call timer_stop(s:ReviewModeTimer)
    endif
    echo
endfunction

function! s:PrintReviewModeInStatusLine()
    if s:ReviewModeActive == 1
        echohl ModeMsg
        echo '-- REVIEW --'
        echohl None
    endif
    echo
endfunction
