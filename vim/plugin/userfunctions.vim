" Mostly for reproducing scenarios for Vrapper
function! UserToggleSelection()
  if &selection == 'exclusive'
    set selection=inclusive
    echo "Selection == inclusive"
  else
    set selection=exclusive
    echo "Selection == exclusive"
  endif
endfunction

function! UserToggleConcealing()
  if &conceallevel == '0'
    let &conceallevel = g:Concealer_ConcealLevel
    echo "Concealing enabled"
  else
    set conceallevel=0
    echo "Concealing disabled"
  endif
endfunction
