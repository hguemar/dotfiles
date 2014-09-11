# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions
PYTHONSTARTUP=~/.pythonrc.py

export PATH
export CLASSPATH
export PYTHONSTARTUP
export EDITOR='emacs'
export ALTERNATE_EDITOR='vim'

######
alias man='LANG=C man'
alias screen='screenie'
alias emc='emacsclient -c'
alias emt='emacsclient -t'
alias enox='emacs-nox'
alias vi='vim'
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'

source  /usr/share/git-core/contrib/completion/git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=1 # (*) unstage (+) staged
GIT_PS1_SHOWSTASHSTATE=1 # ($) stash non empty
GIT_PS1_SHOWUNTRACKEDFILES=1 # (%) untracked file
GIT_PS1_SHOWUPSTREAM="auto"

RED='\[\e[4m\e[0;31m\]'
BLUE='\[\e[4m\e[0;34m\]'
ORANGE='\[\e[4m\e[0;33m\]'
CYAN='\[\e[4m\e[0;36m\]'
RST='\[\e[4m\e[0m\]'
PS1='['$ORANGE'\u'$RST'@'$BLUE'\h'$RST' '$RED'\W'$RST''$CYAN'$(__git_ps1 " (%s)")'$RST']\$ '

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

#THIS MUST BE AT THE END OF THE FILE FOR GVM TO WORK!!!
[[ -s "/home/haikel/.gvm/bin/gvm-init.sh" ]] && source "/home/haikel/.gvm/bin/gvm-init.sh"
