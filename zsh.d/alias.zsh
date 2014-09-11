## alias
alias man='LANG=C man'
alias screen='screenie'
alias vi='vim'
alias enox='emacs -nw'
alias emw='emacs -nw'
alias emc='emacsclient -c -a ""'
alias emt='emacsclient -t -a ""'
alias df='df --human-readable'
alias du='du --human-readable'
alias grep='grep --color=auto'
alias md='mkdir'
alias rd='rmdir'
alias ll='ls -l'
alias lz='ls -Z'
alias sudosh='sudo $SHELL'
alias vbm='VBoxManage'
alias startvm='VBoxManage startvm --type headless'
function stopvm {
    VBoxManage controlvm $1 poweroff
}
# no spelling correction
alias mv='nocorrect mv'
alias cp='nocorrect cp'
alias mkdir='nocorrect mkdir'
alias ps='nocorrect ps'
alias ssh='nocorrect ssh'
alias scp='nocorrect scp'
# git-svn
alias dcommit='git svn dcommit'
alias drebase='git svn rebase'
# cmake
function ccmake-clang {
    ccmake -DCMAKE_C_COMPILER=$(which clang) -DCMAKE_CXX_COMPILER=$(which clang++) "$@"
}
