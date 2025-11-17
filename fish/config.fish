# env vars
set -gx HOMEBREW_NO_ENV_HINTS 1
set -gx RUSTFLAGS "-C linker=clang -C link-arg=-fuse-ld=lld"
set -gx CFLAGS "clang -std=c99 -Wall -Werror"
set -gx VIRTUAL_ENV_DISABLE_PROMPT 1
set -gx CARGO_TARGET_DIR "$HOME/.cargo-target"

# safe PATH adding
function __safe_add_path
    for p in $argv
        if test -d $p
            set -g PATH $p $PATH
        end
    end
end

__safe_add_path ~/.local/bin
__safe_add_path /opt/homebrew/bin
__safe_add_path ~/.rustup/toolchains/stable-aarch64-apple-darwin/bin

# starship (only if installed)
if type -q starship
    starship init fish --print-full-init | source
    set -gx STARSHIP_CONFIG "$HOME/.config/starship/starship.toml"
end

# manpager
if type -q bat
    set -gx MANPAGER bat
end

# greeting
set fish_greeting
function fish_greeting
    if test -x ~/.local/bin/nanofetch
        ~/.local/bin/nanofetch
    end
end

# safe alias wrapper
function __safe_alias
    if type -q $argv[2]
        alias $argv[1]="$argv[2]"
    end
end

# basic aliases
alias cls="clear"
alias so="source ~/dotfiles/fish/config.fish"
alias fish_config="nvim ~/.config/fish/config.fish"

# ls / tree
if type -q eza
    alias ls="eza -l --color=always --group-directories-first --icons=always --no-time --no-user"
    alias la="eza -a --color=always --group-directories-first --icons"
    alias ll="eza -l --color=always --group-directories-first --icons"
    alias lt="eza -aT --color=always --group-directories-first --icons"
    alias tree="eza --tree"
else
    alias ls="ls -lah"
end

# cat
if type -q bat
    alias cat="bat -p"
end

# git
__safe_alias g git
alias gs="git status"
alias gc="git commit -m"
alias gp="git push"

# navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
if type -q z
    alias cd="z"
end

# search tools
__safe_alias grep rg
__safe_alias find fd

# brew
if type -q brew
    alias xi="brew install"
    alias xr="brew uninstall"
    alias xq="brew info"
end

# yt-dlp
if type -q yt-dlp
    alias download_song="yt-dlp -x --audio-format mp3 --embed-thumbnail"
end

# file copy
function copy
    set count (count $argv | tr -d \n)
    if test "$count" = 2; and test -d "$argv[1]"
        command cp -r (string trim -r -c '/') $argv[1] $argv[2]
    else
        command cp $argv
    end
end

# backup
function backup --argument file
    if test -f $file
        cp $file $file.bak
    else
        echo "file not found: $file"
    end
end

# yplay
if type -q mpv; and type -q yt-dlp; and type -q fzf
    function yplay
        set -l q (read -P "Search YouTube: ")
        test -z "$q"; and echo "no query"; and return

        set -l url (yt-dlp "ytsearch10:$q" --flat-playlist \
            --print "%(title)s | https://youtu.be/%(id)s" | fzf | cut -d'|' -f2 | string trim)

        test -z "$url"; and echo "no selection"; and return

        mpv --no-video (yt-dlp -f bestaudio -g $url)
    end
end

# ydownload
if type -q yt-dlp; and type -q fzf
    function ydownload
        set -l q (read -P "Search YouTube: ")
        test -z "$q"; and echo "no query"; and return

        set -l url (yt-dlp "ytsearch10:$q" --flat-playlist \
            --print "%(title)s | https://youtu.be/%(id)s" | fzf | cut -d'|' -f2 | string trim)

        test -z "$url"; and echo "no selection"; and return

        echo "Downloading: $url"
        yt-dlp -f bestaudio --extract-audio --audio-format mp3 \
            --audio-quality 0 --embed-thumbnail --add-metadata \
            --output "$HOME/Downloads/%(title)s.%(ext)s" $url
    end
end

# zoxide
if type -q zoxide
    zoxide init fish | source
end

# hydro
if set -q hydro_multiline
    set -g hydro_multiline true
end
