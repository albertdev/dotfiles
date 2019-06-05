"
" Sets up a bunch of keyboard mappings which can help with manually reviewing unified diff files.
" Run :StartReview to set it up. The diff file will be modified by prepending a legend, hunks which are
" reviewed are prepended with X or R
"

command! StartReview call s:StartReview()

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

    " Fill location list
    lvimgrep /diff --git/ %
    lopen
    " Return to editor
    wincmd p

    nnoremap <buffer> n :call <sid>MoveNext()<CR>
    nnoremap <buffer> N :call <sid>MovePrevious()<CR>
    nnoremap <buffer> x :call <sid>MarkReviewed()<CR>
    nnoremap <buffer> r :call <sid>MarkRejected()<CR>
    nmap <buffer> w :ll<CR>zozt

    " Focus first hunk
    normal w
endfunction

function! GetDiffFold(lnum)
    if getline(a:lnum) =~? '\v^(. )?diff --'
        return '>1'
    endif

    return '1'
endfunction

function! <sid>MoveNext()
    normal! zM
    lnext
    normal! zo
    normal! zt
endfunction

function! <sid>MovePrevious()
    normal! zM
    lprev
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
    let startofdiffLine = search('\v^--- ')
    if startofdiffLine != 0
        call cursor(startofdiffLine, 1)
        normal! O
        " The 'normal' command will reset mode. Do it again
        startinsert
    endif
endfunction
