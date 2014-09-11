zmodload zsh/parameter
test $aliases[run-help] && unalias run-help
autoload -Uz run-help
autoload run-help-git
autoload run-help-svn
autoload run-help-sudo
autoload run-help-openssl
export HELPDIR=$HOME/.zsh.d/helpdir
