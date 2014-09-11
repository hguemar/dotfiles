# awscli
AWS_CONFIG_DIR=$HOME/.aws
BOTO_CONFIG=$HOME/.boto
AWSCLI_CONFIG=$HOME/.awscli
EUCARC_CONFIG=$HOME/.eucarc

if $(which aws &>/dev/null); then
    export AWS_CONFIG_FILE=$HOME/.awscli
    source $(which aws_zsh_completer.sh)
fi

