## Helps to make a custom completion function for an alias.
# Found it at http://unix.stackexchange.com/a/4220/70874
# Copied from http://ubuntuforums.org/showthread.php?t=733397
function make-completion-wrapper () {
  local function_name="$2"
  local arg_count=$(($#-3))
  local comp_function_name="$1"
  shift 2
  local function="
    function $function_name {
      ((COMP_CWORD+=$arg_count))
      COMP_WORDS=( "$@" \${COMP_WORDS[@]:1} )
      "$comp_function_name"
      return 0
    }"
  eval "$function"
  # Debugging
  #echo $function_name
  #echo "$function"
}

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
#use ctl keys to move forward and back in words
# Linux
bind '"OC":forward-word'
bind '"OD":backward-word'
# Windows, msysgit with ConsoleZ
## Commented out, seems modifiers + cursors don't work.
#bind '"[C":forward-word'
#bind '"[D":backward-word'
