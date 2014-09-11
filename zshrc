##############################################################################
## general configuration
##############################################################################
# source functions
source ~/.zsh.d/functions.zsh
# source current hostfile
host=$(get_hostname)
host_alt='${host%%[[:digit:]]'

load_module "$host"
load_module "$host_alt" 
load_module zen
load_module rvm "-d $HOME/.rvm"
load_module alias
load_module env
load_module gvm

# setup ssh keychain for builder users
if [[ "$USER" = "builder" ]]
then
    setup_keychain
fi

##############################################################################
## zsh configuration
##############################################################################
# configure completion
load_module completion
load_module awscli # must be loaded after completion module
# configure run-help
load_module help
# configure mime-handler
load_module mime-handlers

# enable command auto-correction
setopt correctall
# print bad pattern (ie:" print [a" )
setopt bad_pattern
# use extended_glob
setopt extended_glob
setopt null_glob # replace failed expression by null
# enable autocd
setopt autocd
# enable short loops (ie: for file in $.pdf; echo $file)
setopt shortloops
# never beep NEVER !
unsetopt beep
unsetopt hist_beep
unsetopt list_beep
## no clobber
unsetopt clobber
# ask before rm *
# Yeah, that's plain stupid
setopt rm_star_silent
# wait ten seconds or expand
unsetopt rm_star_wait
# select word-style
autoload -U select-word-style
select-word-style b # select bash style

# display error_code if != 0
#setopt print_exit_value

# colorize stderr
prexec() {
    exec 2>>(while read line; do
        print "$bg[yellow]$fg_bold[red]${(q)line}$reset_color" > /dev/tty;
        print -n $'\0';
        done &)
}

# zcalc
autoload -U zcalc

# zmv
autoload -U zmv

# zftp
zmodload zsh/zftp
autoload -U zfinit

##############################################################################
## keybindings configuration
##############################################################################
load_module keybindings

##############################################################################
## history configuration
##############################################################################
# save last 1k entries in history
export HISTORY=1000
export SAVEHIST=1000
# history file
export HISTFILE=$HOME/.history
# all zsh sessions append their history incrementally
setopt inc_append_history
# all zsh sessions share their history
#setopt share_history
# don't save duplicates in history
setopt hist_ignore_all_dups
# command preceded by a space won't be saved in history
setopt hist_ignore_space

##############################################################################
## Prompt configuration
##############################################################################
load_module prompt

##############################################################################
# zsh syntaxic coloration
##############################################################################
source ~/.zsh.d/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

#THIS MUST BE AT THE END OF THE FILE FOR GVM TO WORK!!!
[[ -s "/home/haikel/.gvm/bin/gvm-init.sh" ]] && source "/home/haikel/.gvm/bin/gvm-init.sh"

