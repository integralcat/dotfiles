# ~/.config/fish/config.fish
# Minimal, safe, and robust fish config for dotfiles
# Gourav — keep this in dotfiles/fish/config.fish and let home-manager symlink it.

# === ENV (fish style) ===
set -x HOMEBREW_NO_ENV_HINTS 1
set -x VIRTUAL_ENV_DISABLE_PROMPT 1

# === PATH (set these early so init commands find binaries) ===
# Prepend frequently used locations to PATH (fish 'set -p' appends; 'set -U' for universal)
set -p PATH $HOME/.cargo/bin
set -p PATH $HOME/.local/bin
set -p PATH $HOME/.pub-cache/bin
set -p PATH $HOME/.platformio/penv/bin
set -p PATH $HOME/.emacs.d/bin
set -p PATH $HOME/.local/share/gem/ruby/3.4.0/bin
# nix profile bin (ensure this exists if you used `nix profile install`)
set -p PATH $HOME/.nix-profile/bin

# === GREETING + PROMPT ===
set fish_greeting
# starship config path (guarded later)
set -x STARSHIP_CONFIG "$HOME/.config/starship/starship.toml"

# === STARSHIP (init only if available) ===
if type -q starship
    # starship init prints fish code — source it safely
    source (starship init fish --print-full-init | psub)
end

# === ZOXIDE (init only if available) ===
if type -q zoxide
    zoxide init fish | source
end

# === FASTFETCH (macOS) ===
if type -q fastfetch
    fastfetch -l none
end

# === NIX integration (if present) ===
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
alias so="source $HOME/dotfiles/fish/config.fish"
alias fish_config="nvim $HOME/.config/fish/config.fish"

# File utilities (guarded)
if type -q exa
    alias ls='exa -l --color=always --group-directories-first --icons --no-time --no-user'
    alias la='exa -a --color=always --group-directories-first --icons'
    alias ll='exa -l --color=always --group-directories-first --icons'
    alias lt='exa -aT --color=always --group-directories-first --icons'
else if type -q eza
    alias ls='eza -l --icons --group-directories-first'
    alias la='eza -a --icons'
    alias ll='eza -l --icons'
    alias lt='eza --tree'
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
    alias vfzf='nvim "$(fzf)"'
end

# Git helper
if type -q git
    alias g='git'
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

# Process helpers
function psmem
    ps aux | sort -nrk 4
end
function psmem10
    psmem | head -10
end

# === NAVIGATION: use zoxide safely (fallback to builtin cd) ===
if type -q zoxide
    function cd --wraps=cd --description 'zoxide + builtin cd'
        if test (count $argv) -eq 0
            builtin cd
        else if test -d $argv[1]
            builtin cd $argv
        else
            zoxide query $argv[1] 2>/dev/null | read -l target
            if test -n "$target"
                builtin cd $target
            else
                echo "cd: no such file or zoxide match: $argv[1]"
            end
        end
    end
end

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

# === DONE NOTIFICATIONS === (keep as you had)
set -U __done_min_cmd_duration 10000
set -U __done_notification_urgency_level low
