" Always show statusline
set laststatus=2

set statusline=
set statusline=(%3n)\   "buffer number
set statusline+=%t\     "tail of the filename
set statusline+=[%{strlen(&fenc)?&fenc:'none'}, "file encoding
" Vimtip 735 from Wikia - Indicates whether there's a BOM or not https://vim.fandom.com/wiki/Show_fileencoding_and_bomb_in_the_status_line
set statusline+=%{(exists('+bomb')\ &&\ &bomb)?'B,':''}
set statusline+=%{&ff}] "file format
set statusline+=%h      "help file flag
set statusline+=%m      "modified flag
set statusline+=%r      "read only flag
set statusline+=%y      "filetype
set statusline+=%=      "left/right separator
set statusline+=%v(%c), "cursor column
set statusline+=%l/%L   "cursor line/total lines
set statusline+=\ %P    "percent through file
