# Git stuff
alias "ifconfig=ipconfig -all"
alias "gits=git status"
alias "giti=git diff --cached"
alias "gitsr=git svn rebase || ( git stash ; git svn rebase ; git stash pop )"
alias "gitsf=git svn fetch"
alias "gitfa=git fetch --all"
alias "gitff=git pull --ff-only"
alias "gitmf=git merge --ff-only"

make-completion-wrapper _git _git_merge_ffonly git merge --ff-only
complete -F _git_merge_ffonly gitmf

make-completion-wrapper _git _git_pull_ffonly git pull --ff-only
complete -F _git_pull_ffonly gitff
