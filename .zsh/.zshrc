# Lines configured by zsh-newuser-install
export HISTFILE=~/.histfile
export HISTSIZE=5000
export SAVEHIST=5000
setopt appendhistory autocd
bindkey -e                  # Emacs mode
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/jacobsb/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

setopt auto_pushd
setopt pushd_ignore_dups
setopt extended_glob
for zshrc_snipplet in ~/.zsh/rc/S[0-9][0-9]*[^~] ; do
    source $zshrc_snipplet
done
#
