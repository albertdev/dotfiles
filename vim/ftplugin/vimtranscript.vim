set wrap
set textwidth=0

map <buffer>  <M-Up>  <Plug>(transcribe-seekcode-backward)
imap <buffer> <M-Up>  <Plug>(transcribe-seekcode-backward)

map <buffer>  <M-Down> <Plug>(transcribe-seekcode-forward)
imap <buffer> <M-Down> <Plug>(transcribe-seekcode-forward)

map <buffer>  <C-Up>  <Plug>(transcribe-findcode-backward)
imap <buffer> <C-Up>  <Plug>(transcribe-findcode-backward)

map <buffer>  <C-Down> <Plug>(transcribe-findcode-forward)
imap <buffer> <C-Down> <Plug>(transcribe-findcode-forward)

map <buffer> <M-Right> <Plug>(transcribe-inc-frames-seek)
map <buffer> <M-Left> <Plug>(transcribe-dec-frames-seek)
imap <buffer> <M-Right> <Plug>(transcribe-inc-frames-seek)
imap <buffer> <M-Left> <Plug>(transcribe-dec-frames-seek)

map <buffer>  <S-Return> <Plug>(transcribe-seekcode)
imap <buffer> <S-Return> <Plug>(transcribe-seekcode)

map <buffer>  <Tab> <Plug>(transcribe-toggle-pause)
imap <buffer> <Tab> <Plug>(transcribe-toggle-pause)

map <buffer> <C-A> <Plug>(transcribe-inc-seconds-seek)
map <buffer> <C-X> <Plug>(transcribe-dec-seconds-seek)

map <buffer>  <C-T> <Plug>(transcribe-insertcode)
imap <buffer> <C-T> <Plug>(transcribe-insertcode)

nmap <buffer> dc <Plug>(transcribe-deletecode)

map <buffer>  <C-Tab> <Plug>(transcribe-seek-backward-long)
imap <buffer> <C-Tab> <Plug>(transcribe-seek-backward-long)

map <buffer>  <PageDown> <Plug>(transcribe-seek-forward)
imap <buffer> <PageDown> <Plug>(transcribe-seek-forward)

map <buffer>  <PageUp>   <Plug>(transcribe-seek-backward)
imap <buffer> <PageUp>   <Plug>(transcribe-seek-backward)


nnoremap <buffer> <F7>  :<C-U>TranscribeSpeedSet 0.7<cr>
nnoremap <buffer> <F8>  :<C-U>TranscribeSpeedSet 0.8<cr>
nnoremap <buffer> <F9>  :<C-U>TranscribeSpeedSet 0.9<cr>
nnoremap <buffer> <F10> :<C-U>TranscribeSpeedSet 1.0<cr>
nnoremap <buffer> <F11> :<C-U>TranscribeSpeedSet 1.1<cr>
nnoremap <buffer> <F12> :<C-U>TranscribeSpeedSet 1.2<cr>

" Automatically strip trailing whitespace in vimtranscript
function! StripTrailingWhitespace()
    let pos = getpos(".")
    %s/\s\+$//e
    if pos != getpos(".")
        echo "Stripped whitespace\n"
    endif
    call setpos(".", pos)
endfunction
autocmd BufWritePre <buffer> :call StripTrailingWhitespace()