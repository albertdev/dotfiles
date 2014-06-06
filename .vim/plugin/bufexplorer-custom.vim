" Buffer viewer key binds.
"
" A special check is made to switch focus away from the NERDTree.
" Otherwise such a buffer viewer would trigger inside the tree buffer and
" treat its vertical "magic view" as a regular window split.

nnoremap \bv :if exists("b:NERDTreeType") \| wincmd p \| endif \| BufExplorerVerticalSplit<CR>j
nnoremap \bs :if exists("b:NERDTreeType") \| wincmd p \| endif \| BufExplorerHorizontalSplit<CR>j
nnoremap \be :if exists("b:NERDTreeType") \| wincmd p \| endif \| BufExplorer<CR>j

let g:bufExplorerShowRelativePath=1
" Only show buffers which have been opened in the current tab.
let g:bufExplorerShowTabBuffer=1
