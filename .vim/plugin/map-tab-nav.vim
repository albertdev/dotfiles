" Use Ctrl+Tab to switch tabs in any mode, like most UIs do.
nmap <C-S-tab> :tabprevious<cr>
nmap <C-tab> :tabnext<cr>
nmap <C-t> :tabnew<cr>
map <C-t> :tabnew<cr>
map <C-S-tab> :tabprevious<cr>
map <C-tab> :tabnext<cr>
imap <C-S-tab> <C-o>:tabprevious<cr>
imap <C-tab> <C-o>:tabnext<cr>
imap <C-t> <C-o>:tabnew<cr>
" Confusing more often than not. Also clobbers windowing cmd mapping.
"map <C-w> :tabclose<cr>

