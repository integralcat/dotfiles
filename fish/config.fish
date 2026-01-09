if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
    source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
end

# env vars
set -gx HOMEBREW_NO_ENV_HINTS 1
# set -gx RUSTFLAGS "-C linker=clang -C link-arg=-fuse-ld=lld"
set -gx CFLAGS "-std=c99 -Wall -Werror"
set -gx VIRTUAL_ENV_DISABLE_PROMPT 1
set -gx CARGO_TARGET_DIR "$HOME/.cargo-target"
set -gx EDITOR nvim
# /usr/share/man's Manpages
if type -q xcrun
    set -gx MANPATH $MANPATH (xcrun --show-sdk-path)/usr/share/man
end

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
end

# direnv
if type -q direnv
    direnv hook fish | source
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
alias reload="source ~/dotfiles/fish/config.fish"
alias fish_config="nvim ~/.config/fish/config.fish"
alias vi=nvim

# ls / tree
if type -q eza
    alias ls='eza -l --group-directories-first --no-user --no-time'
    alias la='eza -la --group-directories-first'
    alias ll='eza -l --group-directories-first'
    alias lt='eza -aT'
    alias ldot='eza -a --ignore-glob="[!.]*"'
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

# search tools
__safe_alias grep rg
__safe_alias find fd

# brew
if type -q brew
    alias xi="brew install"
    alias xr="brew uninstall"
    alias xq="brew info"
end

if type -q aria2c
    alias aget="aria2c -x 16 -s 48 -k 4M --file-allocation=falloc"
    alias agetslow='aria2c -x 8 -s 16 --enable-http-pipelining=true'
    alias ator='aria2c --enable-dht=true --enable-dht6=true --bt-max-peers=128 --seed-time=0 --seed-ratio=0.15'
    alias amag='aria2c --enable-dht=true --enable-dht6=true --bt-max-peers=128 --seed-time=0 --seed-ratio=0.15'
    alias aresume="aria2c --input-file=$HOME/.aria2/aria2.session --save-session=$HOME/.aria2/aria2.session"
end

# backup
function backup --argument file
    if test -f $file
        cp $file $file.bak
    else
        echo "file not found: $file"
    end
end

# zoxide
if type -q zoxide
    zoxide init fish | source
end


# Auto-start tmux (only if available)
if status is-interactive
    if not set -q TMUX
        if command -q tmux

            set SESSION main
            set LOCK /tmp/tmux-main.lock

            if not test -e $LOCK
                touch $LOCK

                tmux has-session -t $SESSION 2>/dev/null
                if test $status -ne 0
                    tmux new-session -d -s $SESSION -n fish
                    tmux new-window -t $SESSION -n nvim
                    tmux new-window -t $SESSION -n misc
                end

                tmux attach -t $SESSION
                exit
            end
        end
    end
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

if test (uname) = Darwin
    function develop --description "Init nix flake + direnv"
        set template devshell
        set dir .

        switch (count $argv)
            case 1
                set template $argv[1]
            case 2
                set dir $argv[1]
                set template $argv[2]
        end

        if not test -d $dir
            echo "Directory '$dir' does not exist"
            return 1
        end

        pushd $dir >/dev/null

        if test -e flake.nix
            echo "flake.nix already exists — aborting"
            popd >/dev/null
            return 1
        end

        nix flake init -t github:integralcat/nix-templates#$template

        if not test -e .envrc
            echo "use flake" > .envrc
            direnv allow
        else
            echo ".envrc already exists — not touching it"
        end

        popd >/dev/null
    end
end
