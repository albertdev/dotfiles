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
    set conceallevel=1
    set concealcursor=nc
    echo "Concealing enabled"
  else
    set conceallevel=0
    echo "Concealing disabled"
  endif
endfunction
