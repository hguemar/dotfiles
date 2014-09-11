## fix keyboard annoyances
typeset -A key
## get key from terminfo
key[Home]=${terminfo[khome]}
key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}
## reset keybindings
[[ -n "${key[Home]}"    ]]  && bindkey  "${key[Home]}"    beginning-of-line
[[ -n "${key[End]}"     ]]  && bindkey  "${key[End]}"     end-of-line
[[ -n "${key[Insert]}"  ]]  && bindkey  "${key[Insert]}"  overwrite-mode
[[ -n "${key[Delete]}"  ]]  && bindkey  "${key[Delete]}"  delete-char
[[ -n "${key[Up]}"      ]]  && bindkey  "${key[Up]}"      up-line-or-history
[[ -n "${key[Down]}"    ]]  && bindkey  "${key[Down]}"    down-line-or-history
[[ -n "${key[Left]}"    ]]  && bindkey  "${key[Left]}"    backward-char
[[ -n "${key[Right]}"   ]]  && bindkey  "${key[Right]}"   forward-char
[[ -n "${key[PageUp]}"      ]]  && bindkey  "${key[PageUp]}"      up-line-or-history
[[ -n "${key[PageDown]}"    ]]  && bindkey  "${key[PageDown]}"    down-line-or-history
# few awesome keybindings
bindkey ' ' magic-space # magic is awesome!
bindkey ';5D' emacs-backward-word
bindkey ';5C' emacs-forward-word
bindkey ';3D' emacs-backward-word
bindkey ';3C' emacs-forward-word
bindkey '^u' backward-kill-line
# to find keys: C-v then type key 
# \e is meta
bindkey '^?' backward-delete-char
bindkey '^[^e' backward-delete-word

# insert sudo before commands using M-f
zle -N insert-sudo-prefix
bindkey "^[s" insert-sudo-prefix

