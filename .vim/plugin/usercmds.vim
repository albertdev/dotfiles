command! -bang C Bdelete<bang>

" From http://unix.stackexchange.com/a/58748/70874
command! -range Vis call setpos('.', [0,<line1>,0,0]) |
                    \ exe "normal V" |
                    \ call setpos('.', [0,<line2>,0,0])

" Custom extension
command! -range BVis call setpos('.', [0,<line1>,0,0]) |
                    \ exe "normal <C-V>" |
                    \ call setpos('.', [0,<line2>,0,0]) |
                    \ exe "normal $"
