# return current hostname
function get_hostname {
    echo $(hostname -s)
}

# load module
function load_module {
    function _load_module {
        [[ -f "$HOME/.zsh.d/$1.zsh" ]] && source "$HOME/.zsh.d/$1.zsh"
    }
    if [[ $# == 1 ]]; then
        _load_module $1
    elif

    if [ ${(z)2} ]; then
        _load_module $1
    elif
}

# insert sudo
function insert-sudo-prefix {
    local prefix
    prefix="sudo"
    BUFFER="$prefix $BUFFER"
    CURSOR=$(($CURSOR + $#prefix + 1))
}

# echo to stderr
function echoerr {
    echo $@ >&2
}

# setup keychain
function setup_keychain {
    if $(which keychain &> /dev/null); then
        setopt extended_glob # might not be enabled yet
    # only add private keys and ensure they have the proper permissions
        keychain --quiet --nogui \
            $HOME/.ssh/*~*(known|config|authorized|pub|seahorse)*(f600)
        source "$HOME/.keychain/$HOSTNAME-sh"
    fi
}

# save gpg keys
function gpg_export_keychain {
    while getopts ":c" opt; do
        case $opt in
        c)
            echo "export keychain as a combined bundle"
            local combined=1
            ;;
        esac
    done
    shift $(($OPTIND-1)) # restore everything

    if [ "$combined" ]; then
        gpg -a --export > "${1:=default}-combined.key"
        gpg -a --export-secret-keys >> "$1-combined.key"
        gpg --export-ownertrust > "$1-trust.db"
    else
        gpg -ao "${1:=default}-pub.key" --export
        gpg -ao "$1-private.key" --export-secret-keys
        gpg --export-ownertrust > "$1-trust.db"
    fi
}

# ssh into ec2 machines
function sshaws {
    # $1: instance id
    # $2: user
    if $(which euca-describe-instances &>/dev/null); then
        ssh ${2-:ec2-user}@$(euca-describe-instances $1 | awk '/INSTANCE/ { print $4 }')
    else
        echoerr "Please install euca2ools"
    fi
}

function sshaws2 {
    # $1: name
    # $2: user
    if $(which euca-describe-instances &>/dev/null); then
        ssh ${2-:ec2-user}@$(euca-describe-instances --filter tag:Name=$1 | awk '/INSTANCE/ { print $4 }')
    else
        echoerr "Please install euca2ools"
    fi 
}


# choose default binary
# returns the first one that or the last one if the previous failed
function select_binary {
    for i in ${@:1:$#-1}; do
        which $i &>/dev/null && echo $i && return
    done
    echo $@[$#]
}

# list emacs daemons running
function eml {
    local socks
    local uid=$(id -u)
    socks=($(ls /tmp/emacs$uid/))
    if [[ $#socks  == 0 ]]; then
        echoerr "No emacs daemon running."
        return 1
    else
        echoerr "Currently running emacs daemons:"
        for i in $socks; do
            echo "  $i"
        done
        return 0
    fi;
}

# kill emacs daemon
# -f force the killing of the daemon without caring of the buffers
function emk {
    eml 1>/dev/null || return
    local cmd
    local killcmd
    local force
    local target
    cmd="emacsclient --no-wait "
    killcmd="'(client-save-kill-emacs)'"
    while getopts ":fs:h" opt; do
        case $opt in
            f)
                force=1
                killcmd="'(kill-emacs)'"
                ;;
            s)
                local targets
                target=$OPTARG
                targets=$(eml 2>/dev/null)
                if [[ -z ${targets[(r)$target]} ]]; then
                    echo "No daemon $target is running"
                    return
                fi
                ;;
            h)
                echoerr "Usage: emk [-f] [-s target] [-h]"
                echoerr "  -f: force stopping emacs daemon"
                echoerr "  -s: select daemon to be stopped"
                echoerr "  -h: display this help message"
                return
                ;;
        esac
    done
    shift $((OPTIND-1))
    test $force && echoerr "force stop emacs daemon"
    test $target && cmd="$cmd --socket-name=$target"
    eval "$cmd --eval $killcmd"
}

function aws-profile {
    if [[ $# != 1 ]]; then
        echoerr "Usage: aws-profile <profile-name>"
        echoerr "Switch AWS tools profile"
        return
    fi

    TPL_NAME=$1
    BOTO_PROFILE="$AWS_CONFIG_DIR/boto-$TPL_NAME"
    EUCARC_PROFILE="$AWS_CONFIG_DIR/eucarc-$TPL_NAME"
    AWSCLI_PROFILE="$AWS_CONFIG_DIR/awscli-$TPL_NAME"

    [[ -e $BOTO_PROFILE ]] && ln -sf $BOTO_PROFILE $BOTO_CONFIG
    [[ -e $EUCARC_PROFILE ]] && ln -sf $EUCARC_PROFILE $EUCARC_CONFIG
    [[ -e $AWSCLI_PROFILE ]] && ln -sf $AWSCLI_PROFILE $AWSCLI_CONFIG
}


# ssh to a libvirt domain
function virt-ssh {
    # we need at least a domain name
    [ "$@" ] || { echo "Usage: $0 [user@]domain" && return 1 }

    array=(${(s/@/)1})
    local domain=""
    local user=""
    local uri=""
    local tmpfile="/tmp/$RANDOM.xml"

    # parse input to retrieve user & domain
    if [[ ${#array[*]} == 2 ]]; then
        user=${array[1]}
        domain=${array[2]}
    else
        domain=$1
    fi

    # retrieve internal ip from the domain
    virsh dumpxml $domain > $tmpfile 2>/dev/null || { echo "Domain $domain does not exist"; return 2 }
    local mac=`xmllint --xpath 'string(//mac/@address)' $tmpfile`
    rm $tmpfile
    local ip=`arp -na | grep $mac | awk '{ data=gsub(/[()]/, "", $2); print $data }'`


    # connect to the domain
    if [[ -z $user ]]; then
        uri=$ip
    else
        uri=$user@$ip
    fi
    ssh $uri
}
