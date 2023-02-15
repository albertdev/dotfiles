command! -bang C Bdelete<bang>

command! CopyPath let @+=expand("%:p") | echo "Copied path '" . expand("%:p") . "' to system clipboard"

" From http://unix.stackexchange.com/a/58748/70874
command! -range Vis call setpos('.', [0,<line1>,0,0]) |
                    \ exe "normal V" |
                    \ call setpos('.', [0,<line2>,0,0])

" Custom extension
command! -range BVis call setpos('.', [0,<line1>,0,0]) |
                    \ exe "normal <C-V>" |
                    \ call setpos('.', [0,<line2>,0,0]) |
                    \ exe "normal $"

" These two are taken from
" http://vim.wikia.com/wiki/Convert_between_hex_and_decimal
" Modified to drop '0x' prefix and pad to two chars.

command! -nargs=? -range Dec2hex call s:Dec2hex(<line1>, <line2>, '<args>')

function! s:Dec2hex(line1, line2, arg) range
  if empty(a:arg)
    if histget(':', -1) =~# "^'<,'>" && visualmode() !=# 'V'
      let cmd = 's/\%V\<\d\+\>/\=printf("%02x",submatch(0)+0)/g'
    else
      let cmd = 's/\<\d\+\>/\=printf("%02x",submatch(0)+0)/g'
    endif
    try
      execute a:line1 . ',' . a:line2 . cmd
    catch
      echo 'Error: No decimal number found'
    endtry
  else
    echo printf('%x', a:arg + 0)
  endif
endfunction

command! -nargs=? -range Hex2dec call s:Hex2dec(<line1>, <line2>, '<args>')

function! s:Hex2dec(line1, line2, arg) range
  if empty(a:arg)
    if histget(':', -1) =~# "^'<,'>" && visualmode() !=# 'V'
      let cmd = 's/\%V0x\x\+/\=submatch(0)+0/g'
    else
      let cmd = 's/0x\x\+/\=submatch(0)+0/g'
    endif
    try
      execute a:line1 . ',' . a:line2 . cmd
    catch
      echo 'Error: No hex number starting "0x" found'
    endtry
  else
    echo (a:arg =~? '^0x') ? a:arg + 0 : ('0x'.a:arg) + 0
  endif
endfunction


" Adapted from Vim tip http://vim.wikia.com/wiki/Change_between_backslash_and_forward_slash 
command! SlashForward let tmp=@/<Bar>s:\\:/:ge<Bar>let @/=tmp<Bar>noh
"command! SlashBack let tmp=@/<Bar>s:/:\\:ge<Bar>let @/=tmp<Bar>noh
command! SlashBack let tmp=@/<Bar>s:/:\\:ge<Bar>let @/=tmp<Bar>noh

" Adapted from https://stackoverflow.com/a/3475364
function! s:DeleteTrailingWS()
    exe "normal mz"
    keeppatterns %s/\s\+$//ge
    exe "normal `z"
endfunc
command! DeleteTrailingWhiteSpace call s:DeleteTrailingWS()

" Builds on Ingo Karkat's Concealer plugin to add a (local) conceal group based on the current search pattern
command! ConcealSearch execute 'ConcealHere '.@/

" Commands which will initiate concealing with patterns I frequently use; traveling through the search history is messy
" and might at some point lose some favorites

" Search logfiles of eSignatures, which has this format:
" INFO  2020-01-01 01:02:03,456 [(request-correlation-guid)] [(tenant identifier)] classname trimmed and/or padded to 80 chars - Message
command! ConcealEsigIds ConcealAdd \[(\w\+-\zs[^]]\+] \[[^]]\+] .\{50}

" Search pattern which matches the filename column in a quickfix list, can be combined with ConcealSearch
command! ConcealQuickListFiles ConcealHere \v^[^|]+\|
