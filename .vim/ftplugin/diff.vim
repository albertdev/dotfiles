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

    nnoremap <buffer> n zM:lnext<CR>zozt
    nnoremap <buffer> N zM:lprev<CR>zozt
    nnoremap <buffer> x :ll<CR>gIX zM:lnext<CR>zozt
    nmap <buffer> r :ll<CR>gIX o
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
