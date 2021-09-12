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
