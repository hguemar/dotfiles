# mime setup
autoload -U zsh-mime-setup
autoload -U zsh-mime-handler
zsh-mime-setup

zstyle ':mime:.mp4:' handler smplayer %s
zstyle ':mime:.avi:' handler smplayer %s
zstyle ':mime:.mkv:' handler smplayer %s

