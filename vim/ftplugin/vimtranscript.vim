set wrap
set textwidth=0
set nojoinspaces
set showbreak=---------->\ \|\ 

let g:TranscribeInsertTimecodeSetsCue = 1
let g:TranscribeInsertTimecodeCorrection = 15

map  <buffer> <M-Up>  <Plug>(transcribe-seekcode-backward)
imap <buffer> <M-Up>  <Plug>(transcribe-seekcode-backward)

map  <buffer> <M-Down> <Plug>(transcribe-seekcode-forward)
imap <buffer> <M-Down> <Plug>(transcribe-seekcode-forward)

map  <buffer> <C-Up>  <Plug>(transcribe-findcode-backward)
imap <buffer> <C-Up>  <Plug>(transcribe-findcode-backward)

map  <buffer> <C-Down> <Plug>(transcribe-findcode-forward)
imap <buffer> <C-Down> <Plug>(transcribe-findcode-forward)

nmap + <Plug>(transcribe-movenextline)
nmap - <Plug>(transcribe-moveprevline)
nmap _ <Plug>(transcribe-underscoreline)
nmap ^ <Plug>(transcribe-startofline)

map  <buffer> <M-Right> <Plug>(transcribe-inc-frames-seek)
map  <buffer> <M-Left> <Plug>(transcribe-dec-frames-seek)
imap <buffer> <M-Right> <Plug>(transcribe-inc-frames-seek)
imap <buffer> <M-Left> <Plug>(transcribe-dec-frames-seek)

map  <buffer> <S-Return> <Plug>(transcribe-seekcode)
imap <buffer> <S-Return> <Plug>(transcribe-seekcode)

map  <buffer> <Tab> <Plug>(transcribe-toggle-pause)
imap <buffer> <Tab> <Plug>(transcribe-toggle-pause)

map  <buffer> <C-A> <Plug>(transcribe-inc-seconds-seek)
map  <buffer> <C-X> <Plug>(transcribe-dec-seconds-seek)

map  <buffer> <C-T> <Plug>(transcribe-insertcode)
imap <buffer> <C-T> <Plug>(transcribe-insertcode)

nmap <buffer> dc <Plug>(transcribe-deletecode)

nmap <buffer> dC J<Plug>(transcribe-deletecode)

map  <buffer> <C-Tab> <Plug>(transcribe-seek-backward-long)
imap <buffer> <C-Tab> <Plug>(transcribe-seek-backward-long)

map  <buffer> <PageDown> <Plug>(transcribe-seek-forward)
imap <buffer> <PageDown> <Plug>(transcribe-seek-forward)

map  <buffer> <PageUp>   <Plug>(transcribe-seek-backward)
imap <buffer> <PageUp>   <Plug>(transcribe-seek-backward)

map  <buffer> <bar>      <Plug>(transcribe-seekautocue)
imap <buffer> <bar>      <Plug>(transcribe-seekautocue)

map  <buffer> <F4>       <Plug>(transcribe-playcurrentinterval)
imap <buffer> <F4>       <Plug>(transcribe-playcurrentinterval)

map  <buffer> <F5>       <Plug>(transcribe-playcurrentcode)
imap <buffer> <F5>       <Plug>(transcribe-playcurrentcode)

nnoremap <buffer> <F7>  :<C-U>TranscribeSpeedSet 0.7<cr>
nnoremap <buffer> <F8>  :<C-U>TranscribeSpeedSet 0.8<cr>
nnoremap <buffer> <F9>  :<C-U>TranscribeSpeedSet 0.9<cr>
nnoremap <buffer> <F10> :<C-U>TranscribeSpeedSet 1.0<cr>
nnoremap <buffer> <F11> :<C-U>TranscribeSpeedSet 1.1<cr>
nnoremap <buffer> <F12> :<C-U>TranscribeSpeedSet 1.2<cr>

" Automatically strip trailing whitespace in vimtranscript
function! StripTrailingWhitespace()
    let pos = getpos(".")
    silent! keeppatterns %s/\s\+$//e
    "if pos != getpos(".")
    "    echo "Stripped whitespace\n"
    "endif
    call setpos(".", pos)
endfunction
autocmd BufWritePre <buffer> :call StripTrailingWhitespace()

iabbrev fullmmx Marble Machine X
iabbrev fullww Wintergatan Wednesdays
iabbrev wgn Wintergatan
iabbrev muscapt [♪ ♪]<Left><Left><Left>
iabbrev muscont [♫]

function! FixCommonErrors()
    %s/\v\C i([ ']|$)/ I\1/g
endfunction

" Vim-transcribe can divide a file but uses 1-based numbering.
" Wintergatan uses 0-based numbering and calls it slots
function! ReplaceSectionsWithSlots()
    keeppatterns %s/\vSection ([0-9]+)/\='Slot ' . (submatch(1)-1)/g
endfunction
