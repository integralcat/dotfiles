# === ENV VARS ===
export HOMEBREW_NO_ENV_HINTS=1
export RUSTFLAGS="-C linker=clang -C link-arg=-fuse-ld=lld"
export DOTLINK_ROOT="$HOME/dotfiles/"

set -x MANPAGER bat
set -gx PATH $HOME/.cabal/bin $PATH $HOME/.ghcup/bin

# === PATH SETUP ===
set -p PATH ~/.platformio/penv/bin
set -p PATH ~/.local/bin
set -p PATH ~/.pub-cache/bin
set -p PATH ~/.emacs.d/bin
set -p PATH $FLYCTL_INSTALL/bin
set -p PATH "$HOME/.local/share/gem/ruby/3.4.0/bin"

# === GREETING + PROMPT ===
set fish_greeting
set VIRTUAL_ENV_DISABLE_PROMPT 1

# === ZOXIDE ===
zoxide init fish | source

# === FASTFETCH (macOS specific) ===
if test "$TERM" = xterm-kitty
    fastfetch --kitty-direct "$HOME/.config/fastfetch/shell_logo.png"
else if status --is-interactive
    if test "$TERM_PROGRAM" != vscode
        fastfetch -l none
    end
end

# === ALIASES ===
alias cls='clear'
alias so='source ~/dotfiles/fish/config.fish'
alias fish_config="nvim ~/.config/fish/config.fish"

# File utilities
alias ls='exa -l --color=always --group-directories-first --icons=always --no-time --no-user '
alias la='exa -a --color=always --group-directories-first --icons'
alias ll='exa -l --color=always --group-directories-first --icons'
alias lt='exa -aT --color=always --group-directories-first --icons'
alias l.="exa -a | egrep '^\.'"
alias cat='bat'
alias tree='eza --tree'

# Text & Terminal
alias man='batman'
alias export='set -x VAR'

# Git
alias g="git"
alias gs="git status"
alias gc="git commit -m"
alias gp="git push"
alias dotfiles='/usr/bin/git --git-dir=$HOME/dotfiles '

# Navigation
alias cd='z'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

# Tools
alias helix='hx'
alias py="python3"
alias vfzf='nvim "$(fzf)"'
alias ssh_phone="ssh -p 8022 u0_a272@192.168.0.101"

# Package managers (adapt for macOS)
alias xi="brew install"
alias xr="brew uninstall"
alias xq="brew info"

# Different Profiles for NVIM 
alias nesx-vi="NVIM_APPNAME=dotfiles/nvim-instances/nesx-vi nvim"

# YouTube
alias download_song="yt-dlp -x --audio-format mp3 --embed-thumbnail"

# Compilers
alias gcc="gcc -Wall -Wextra"
alias g++="g++ -Wall -Wextra"

# Search + File ops
alias grep='rg'
alias find='fd'

# Torrenting and Downloading with Aria2
alias at='aria2c --dir=downloads/ --seed-time=0'
alias am='aria2c --bt-tracker=udp://tracker.openbittorrent.com:80,udp://tracker.opentrackr.org:1337/announce '

# Misc
alias tarnow='tar -acf '
alias untar='tar -xvf '
alias wget='wget -c '
alias psmem='ps aux | sort -nrk 4'
alias psmem10='ps aux | sort -nrk 4 | head -10'

# === FUNCTIONS ===

# History support for !! and !$ (Fish version)
function __history_previous_command
    switch (commandline -t)
        case "!"
            commandline -t $history[1]
            commandline -f repaint
        case "*"
            commandline -i !
    end
end

function __history_previous_command_arguments
    switch (commandline -t)
        case "!"
            commandline -t ""
            commandline -f history-token-search-backward
        case "*"
            commandline -i '$'
    end
end

# Binding bang-bang support
if [ "$fish_key_bindings" = fish_vi_key_bindings ]
    bind -Minsert ! __history_previous_command
    bind -Minsert '$' __history_previous_command_arguments
else
    bind ! __history_previous_command
    bind '$' __history_previous_command_arguments
end

# Better `cp`
function copy
    set count (count $argv | tr -d \n)
    if test "$count" = 2; and test -d "$argv[1]"
        set from (echo $argv[1] | trim-right /)
        set to (echo $argv[2])
        command cp -r $from $to
    else
        command cp $argv
    end
end

# Make a backup of file
function backup --argument filename
    cp $filename $filename.bak
end

function yplay
    set -l query (read -P "Search YouTube: ")
    if test -z "$query"
        echo "No search query given."
        return
    end
    set -l url (yt-dlp "ytsearch10:$query" --flat-playlist --print "%(title)s | https://youtu.be/%(id)s" | fzf | cut -d' | ' -f2 | string trim)
    if test -z "$url"
        echo "No selection made."
        return
    end
    mpv --no-video (yt-dlp -f bestaudio -g $url)
end

function ydownload
    set -l query (read -P "Search YouTube: ")
    if test -z "$query"
        echo "No search query given."
        return
    end
    set -l url (yt-dlp "ytsearch10:$query" --flat-playlist --print "%(title)s | https://youtu.be/%(id)s" | fzf | cut -d' | \
' -f2 | string trim)
    if test -z "$url"
        echo "No selection made."
        return
    end
    echo "Downloading audio from: $url"
    yt-dlp \
        -f bestaudio \
        --extract-audio \
        --audio-format mp3 \
        --audio-quality 0 \
        --embed-thumbnail \
        --add-metadata \
        --output "$HOME/Downloads/%(title)s.%(ext)s" \
        $url
end

# === DONE NOTIFICATIONS ===
set -U __done_min_cmd_duration 10000
set -U __done_notification_urgency_level low
