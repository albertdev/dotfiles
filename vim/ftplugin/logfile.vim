" Toggle concealing on so that only a replacement character is shown.
set conceallevel=1
" Conceal certain regions only in normal mode or command mode. Going to insert, select or visual mode should show what's there.
set concealcursor=nc

" How to hide part of the logs:
" Run syn match Concealed 'regex' conceal

" Handy to quickly see what timestamp we're on at the beginning of the line when the cursor is somewhere near the end of the line
set cursorline
