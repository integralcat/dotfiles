##### CORE #####
setopt PROMPT_SUBST
autoload -Uz compinit
compinit -C -d ~/.cache/zsh/zcompdump

##### PACKAGE MANAGERS #####
[[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"

# Nix
[[ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]] \
  && source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

##### ZINIT #####
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
[[ -d $ZINIT_HOME ]] || git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "$ZINIT_HOME/zinit.zsh"

# nanofetch
/Users/gourav/.local/bin/nanofetch

##### PROMPT (STARSHIP) #####
command -v starship >/dev/null && eval "$(starship init zsh)"

##### PLUGINS (LAZY) #####
zinit ice wait lucid
zinit light zsh-users/zsh-autosuggestions

zinit ice wait lucid
zinit light zsh-users/zsh-syntax-highlighting

zinit ice wait lucid
zinit light zsh-users/zsh-completions

# must load after compinit
zinit ice wait lucid
zinit light Aloxaf/fzf-tab

##### OMZ SNIPPETS (ONLY ESSENTIALS) #####
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found
zinit cdreplay -q

##### KEYBINDINGS #####
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

##### HISTORY #####
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY
setopt BANG_HIST

##### COMPLETION UX #####
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':fzf-tab:*' fzf-command fzf
zstyle ':fzf-tab:complete:*' fzf-preview 'ls --color=auto $realpath'

##### ENV #####
export EDITOR=nvim
export HOMEBREW_NO_ENV_HINTS=1
export VIRTUAL_ENV_DISABLE_PROMPT=1
export CARGO_TARGET_DIR="$HOME/.cargo-target"
# export RUSTFLAGS="-C linker=clang"
export CFLAGS="-std=c99 -Wall"
export CXXFLAGS="-Wall"

##### PATH #####
path_prepend() { [[ -d $1 ]] && path=($1 $path); }
path_prepend ~/.local/bin
path_prepend /opt/homebrew/bin
path_prepend ~/.rustup/toolchains/stable-aarch64-apple-darwin/bin

##### TOOLS #####
command -v fzf     >/dev/null && eval "$(fzf --zsh)"
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"
command -v direnv >/dev/null && eval "$(direnv hook zsh)"

##### ALIASES #####
alias reload='source ~/.zshrc'
alias zshrc='nvim ~/.zshrc'
alias vi=nvim
alias g=git
alias gs='git status'
alias gc='git commit -m'
alias gp='git push'
alias c=clear

##### FILE LISTING #####
if command -v eza >/dev/null; then
  alias ls='eza -l --group-directories-first --no-user --no-time'
  alias la='eza -la --group-directories-first'
  alias ll='eza -l --group-directories-first'
  alias lt='eza -aT'
  alias ldot='eza -a --ignore-glob="[!.]*"'
else
  alias ls='ls -lah'
fi

##### SEARCH / VIEW #####
command -v bat >/dev/null && alias cat='bat -p'
command -v rg  >/dev/null && alias grep=rg
command -v fd  >/dev/null && alias find=fd

##### ARIA2 #####
command -v aria2c >/dev/null && {
  alias aget='aria2c -x16 -s48 -k4M --file-allocation=falloc'
  alias amag='aria2c --enable-dht --bt-max-peers=128 --seed-time=0'
}
