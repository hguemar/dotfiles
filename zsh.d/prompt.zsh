##############################################################################
## prompt setup
##############################################################################
# color setup
autoload -U colors && colors
autoload -U promptinit

reset="%{${reset_color}%}"
white="%{$fg[white]%}"
gray="%{$fg_bold[black]%}"
green="%{$fg[green]%}"
red="%{$fg[red]%}"
yellow="%{$fg[yellow]%}"
bblue="%{$fg_bold[blue]%}"
blue="%{$fg[blue]%}"
cyan="%{$fg[cyan]%}"
reverse="%{$fg[cyan]$bg[white]%}"

##############################################################################
## setup vcs
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git hg bzr svn cvs
#zstyle ':vcs_info:*+*:*' debug true
##
zstyle ':vcs_info:(hg*|git*):*' get-revision true
zstyle ':vcs_info:(hg*|git*):*' check-for-changes true

## Mercurial
zstyle ':vcs_info:hg*:*' formats "${cyan}%s${reset} ${blue}%i${reset}%u%c ${yellow}on ${red}%b${reset} %m"
zstyle ':vcs_info:hg*:*' actionformats "${cyan}%s|${red}%a${reset} ${blue}%i${reset}%u%c ${yellow}on ${red}%b${reset} %m"
zstyle ':vcs_info:hg*:*' hgrevformat "%r" # only show local rev.
zstyle ':vcs_info:hg*:*' branchformat "%b" # only show branch
zstyle ':vcs_info:hg*:*' unstagedstr "${green}●${reset}"
# bookmarks
zstyle ':vcs_info:hg*:*' get-bookmarks true
# MQ settings
zstyle ':vcs_info:hg*:*' get-mq true
zstyle ':vcs_info:hg*:*' get-unapplied true
zstyle ':vcs_info:hg*:*' patch-format "mq(%g):%n/%c %p"
zstyle ':vcs_info:hg*:*' nopatch-format "mq(%g):%n/%c %p"
# hooks
zstyle ':vcs_info:hg*+set-message:*' hooks hg-storerev hg-branchhead

### Store the localrev and global hash for use in other hooks
function +vi-hg-storerev() {
    user_data[localrev]=${hook_com[localrev]}
    user_data[hash]=${hook_com[hash]}
}

### Show marker when the working directory is not on a branch head
# This may indicate that running `hg up` will do something
function +vi-hg-branchhead() {
    local branchheadsfile i_tiphash i_branchname
    local -a branchheads

    local branchheadsfile=${hook_com[base]}/.hg/branchheads.cache

    # Bail out if any mq patches are applied
    [[ -s ${hook_com[base]}/.hg/patches/status ]] && return 0

    if [[ -r ${branchheadsfile} ]] ; then
        while read -r i_tiphash i_branchname ; do
            branchheads+=( $i_tiphash )
        done < ${branchheadsfile}

        if [[ ! ${branchheads[(i)${user_data[hash]}]} -le ${#branchheads} ]] ; then
            hook_com[revision]="${c4}^${c2}${hook_com[revision]}"
        fi
    fi
}

## Git
zstyle ':vcs_info:git*:*' formats "${cyan}%s${reset} ${blue}%12.12i${reset}%u%c ${yellow}on ${red}%b${reset}%m"
zstyle ':vcs_info:git*:*' actionformats "${cyan}%s|${red}%a${reset} ${blue}%12.12i${reset}%u%c ${yellow}on ${red}%b${reset}%m"
zstyle ':vcs_info:git*:*' stagedstr "${green}●${reset}"
zstyle ':vcs_info:git*:*' unstagedstr "${red}●${reset}"

# hooks
zstyle ':vcs_info:git*+set-message:*' hooks git-st git-stash

# Show remote ref name and number of commits ahead-of or behind
function +vi-git-st() {
    local ahead behind remote
    local -a gitstatus

    # Are we on a remote-tracking branch?
    remote=${$(git rev-parse --verify ${hook_com[branch]}@{upstream} \
        --symbolic-full-name 2>/dev/null)/refs\/remotes\/}

    if [[ -n ${remote} ]] ; then
        # for git prior to 1.7
        # ahead=$(git rev-list origin/${hook_com[branch]}..HEAD | wc -l)
        ahead=$(git rev-list ${hook_com[branch]}@{upstream}..HEAD 2>/dev/null | wc -l)
        (( $ahead )) && gitstatus+=( " ${c3}${green}+${ahead}${c2}" )

        # for git prior to 1.7
        # behind=$(git rev-list HEAD..origin/${hook_com[branch]} | wc -l)
        behind=$(git rev-list HEAD..${hook_com[branch]}@{upstream} 2>/dev/null | wc -l)
        (( $behind )) && gitstatus+=( " ${c4}${red}-${behind}${c2}" )

        hook_com[branch]="${hook_com[branch]} ${reset}[${gray}${remote}${(j:/:)gitstatus}${reset}]"
    fi
}

# Show count of stashed changes
function +vi-git-stash() {
    local -a stashes

    if [[ -s ${hook_com[base]}/.git/refs/stash ]] ; then
        stashes=$(git stash list 2>/dev/null | wc -l)
        hook_com[misc]+=" ${reverse}(${stashes} stashed)${reset}"
    fi
}

## for good ol' cvs
zstyle ':vcs_info:cvs:*' formats "${cyan}%s${reset} ${yellow}on ${red}%b${reset}"
zstyle ':vcs_info:cvs:*' actionformats "${cyan}%s|${red}%a${reset} ${yellow}on ${red}%b${reset}"

# setup prompt
#
#export PS1

# executed before prompt is shown
precmd () {
      # set terminal title
      case $TERM in
	  xterm*)
            print -Pn "\e]0;%n@%m: %~\a";
            ;;
      esac
      psvar=()
      vcs_info
      [[ -n $vcs_info_msg_0_ ]] && psvar[1]="$vcs_info_msg_0_"
      # root has a **simpler** prompt
      if [[ "$USER" = "root" ]]; then
	      set_root_prompt
          return
      elif [[ "$EUID" = "0" ]]; then
          user_color=${red} # default is green
      fi
      set_user_prompt
}

set_user_prompt () {
    PS1="${yellow}┌─(${user_color:-${green}}%n${reset}${yellow}@${bblue}%m${reset}${yellow})──────────────(%~)${reset}"
    PS1+="%(1V.${yellow}──────────────(${reset}$psvar[1]${yellow})${reset}.)
${yellow}└─${reset}%# "
    export PS1
#    set_rprompt
}

# no prompt pimpin' for root
set_root_prompt () {
    PS1="${red}%n${reset}@${bblue}%m${reset} ${yellow}%~${reset} %# "
    export PS1
    set_rprompt
}

set_rprompt () {
    # display error code
    export RPS1="%(0?.$green.$red)(%?)${reset}"
}
