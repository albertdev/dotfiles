" This file makes mappings inspired by tpope/unimpaired.vim
" I didn't feel like importing a whole bunch of unknown shortcuts so I just reinvented those which seemed interesting.

" TODO: Mappings for inkarkat/vim-QuickFixCurrentNumber
noremap [L :<C-U>lfirst<CR>zv
noremap ]L :<C-U>llast<CR>zv
noremap [l :<C-U>lnext<CR>zv
noremap ]l :<C-U>lprev<CR>zv

noremap [Q :<C-U>cfirst<CR>zv
noremap ]Q :<C-U>clast<CR>zv
noremap [q :<C-U>cnext<CR>zv
noremap ]q :<C-U>cprev<CR>zv

noremap [<SPACE> :<C-U>execute 'put!=repeat(nr2char(10), v:count1)\|silent '']+'<CR>
noremap ]<SPACE> :<C-U>execute 'put=repeat(nr2char(10), v:count1)\|silent ''[-'<CR>
