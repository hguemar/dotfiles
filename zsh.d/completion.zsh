# enable auto-completion
# load completions
fpath=($HOME/.zsh.d/completion $HOME/.zsh.d/zsh-completions/src $fpath)

autoload -U compinit
compinit
autoload -U bashcompinit
bashcompinit

# force rehash if we don't find any completion
_force_rehash() {
  (( CURRENT == 1 )) && rehash
  return 1 # Because we didn't really complete anything
}

# completers
zstyle ':completion:*' completer _force_rehash _complete _approximate 
# completion menu selection
zstyle ':completion:*' menu select
# cache completion
zstyle ':completion::complete:*' use-cache 1
## specific completion
# kill
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:kill:*:processes' list-colors "=(#b) #([0-9]#)*(#b)=36=31"

# pew pew
which pew &>/dev/null && source $(pew shell_config)

# command not found handler
function command_not_found_handler() {
  local command="$1"
  rehash
  return 1
}

