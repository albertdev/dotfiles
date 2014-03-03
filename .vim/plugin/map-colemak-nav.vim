" Based on an idea from Shai Coleman: when using the Colemak keyboard
" layout, the keys UNEI form an inverted-T cluster of keys similar to
" the cursor keys or a QWERTY gamer's WASD keys, making for more
" intuitive scrolling compared to HJKL (which is all over the place
" on Colemak).
" In this case, use CTRL+[UNEI] to be able to use those keys in ANY
" mode and to avoid clobbering keys in normal mode like 'n' for find
" next, 'i' to enter insert mode, 'u' to undo etc.
nnoremap <C-n> h
xnoremap <C-n> h
onoremap <C-n> h
nnoremap <C-u> gk
xnoremap <C-u> gk
onoremap <C-u> gk
nnoremap <C-e> gj
xnoremap <C-e> gj
onoremap <C-e> gj
nnoremap <C-i> l
xnoremap <C-i> l
onoremap <C-i> l
inoremap <C-n> <Left>
"cnoremap <C-n> <Left>
inoremap <C-u> <C-o>gk
"cnoremap <C-u> <Up>
inoremap <C-e> <C-o>gj
"cnoremap <C-e> <Down>
inoremap <C-i> <Right>
"cnoremap <C-i> <Right>
