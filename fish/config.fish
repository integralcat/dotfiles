# ~/.config/fish/config.fish

# === ENV (fish style) ===
set -x HOMEBREW_NO_ENV_HINTS 1
set -x VIRTUAL_ENV_DISABLE_PROMPT 1

# === PATH (set these early so init commands find binaries) ===
# Prepend frequently used locations to PATH (fish 'set -p' appends; 'set -U' for universal)
set -p PATH $HOME/.local/bin
set -p PATH $HOME/.nix-profile/bin

# === GREETING + PROMPT ===
set fish_greeting
# starship config path (guarded later)
# set -x STARSHIP_CONFIG "$HOME/.config/starship/starship.toml"

# === STARSHIP (init only if available) ===
# if type -q starship
#     # starship init prints fish code — source it safely
#     source (starship init fish --print-full-init | psub)
# end

# === ZOXIDE (init only if available) ===
if type -q zoxide
    zoxide init fish | source
end

# === fastfetch ~ macOS ===
# Note ~ Loads only One time per session
if type -q fastfetch
    if not set -q __FASTFETCH_DONE
        fastfetch -l none
        set -x __FASTFETCH_DONE 1
    end
end

# === NIX integration (if present) ===
source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
# If using nix daemon profile scripts (shell-compatible), use bass to import them when available.
if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
    if type -q bass
        bass source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
    else
        # Try to source with sh -> fish translation fallback
        # This won't always work; having 'bass' is recommended.
        /bin/sh -c "source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" 2>/dev/null
    end
end

# === SAFE ALIASES ===
function _safe_alias --description 'create alias only if cmd exists'
    set -l name $argv[1]
    set -l cmd $argv[2..-1]
    if type -q $cmd[1]
        functions -c $name status >/dev/null 2>&1; or alias $name $cmd
    end
end

# Common aliases (guarded)
alias cls='clear'
alias so="source $HOME/.config/fish/config.fish"
alias fish_config="nvim $HOME/.config/fish/config.fish"

# File utilities (guarded)
if type -q exa
    alias ls='exa -l --color=always --group-directories-first --icons --no-time --no-user'
    alias la='exa -a --color=always --group-directories-first --icons'
    alias ll='exa -l --color=always --group-directories-first --icons'
    alias lt='exa -aT --color=always --group-directories-first --icons'
else if type -q eza
    alias ls='eza -l --color=always --group-directories-first --icons --no-time --no-user'
    alias la='eza -a --color=always --group-directories-first --icons'
    alias ll='eza -l --color=always --group-directories-first --icons'
    alias lt='eza -aT --color=always --group-directories-first --icons'
end

if type -q bat
    alias cat='bat'
end

# Terminal / utils
if type -q rg
    alias grep='rg'
end
if type -q fd
    alias find='fd'
end
if type -q fzf
    alias nf='nvim "$(fzf)"'
end

# Git helper
if type -q git
    alias gs='git status'
    alias gc='git commit -m'
    alias gp='git push'
    function dotfiles
        /usr/bin/git --git-dir=$HOME/dotfiles --work-tree=$HOME $argv
    end
end

# Package manager shortcuts
if type -q brew
    alias xi='brew install'
    alias xr='brew uninstall'
    alias xq='brew info'
end

# YouTube helpers (guarded)
if type -q yt-dlp
    alias download_song='yt-dlp -x --audio-format mp3 --embed-thumbnail'
end

# Utilities
alias tarnow='tar -acf'
alias untar='tar -xvf'
alias wget='wget -c'

# .. helpers
function ..
    cd ..
end
function ...
    cd ../..
end
function ....
    cd ../../..
end
function .....
    cd ../../../..
end
function ......
    cd ../../../../..
end

# === FUNCTIONS ===

# history shortcuts for !! and !$ (fish idiom)
function __history_previous_command
    switch (commandline -t)
        case "!"
            commandline -t $history[1]
            commandline -f repaint
        case "*"
            commandline -i "!"
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

# Bind keys for both bindings style
if test "$fish_key_bindings" = fish_vi_key_bindings
    bind -Minsert '!' __history_previous_command
    bind -Minsert '$' __history_previous_command_arguments
else
    bind '!' __history_previous_command
    bind '$' __history_previous_command_arguments
end

# safer copy
function copy
    if test (count $argv) -eq 2; and test -d $argv[1]
        set from (string trim-right $argv[1] '/')
        set to $argv[2]
        command cp -r $from $to
    else
        command cp $argv
    end
end

function backup --argument filename
    if test -e $filename
        command cp $filename $filename.bak
    else
        echo "backup: file not found: $filename"
    end
end

# yplay / ydownload (guarded tools inside)
if type -q yt-dlp; and type -q fzf; and type -q mpv
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
        set -l url (yt-dlp "ytsearch10:$query" --flat-playlist --print "%(title)s | https://youtu.be/%(id)s" | fzf | cut -d' | ' -f2 | string trim)
        if test -z "$url"
            echo "No selection made."
            return
        end
        echo "Downloading audio from: $url"
        yt-dlp -f bestaudio --extract-audio --audio-format mp3 --audio-quality 0 --embed-thumbnail --add-metadata --output "$HOME/Downloads/%(title)s.%(ext)s" $url
    end
end

# === HYDRO PROMPT (FISHER) ===
set -U hydro_multiline true
