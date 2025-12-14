##### STARTUP PROFILER  #####
# zmodload zsh/zprof

##### POWERLEVEL10K INSTANT PROMPT (MUST BE FIRST) #####
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${USER}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${USER}.zsh"
fi

##### HOMEBREW #####
[[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"

##### ZINIT #####
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
if [[ ! -d $ZINIT_HOME ]]; then
  mkdir -p "${ZINIT_HOME:h}"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "$ZINIT_HOME/zinit.zsh"

##### COMPLETION SYSTEM (FAST) #####
autoload -Uz compinit
compinit -C -d ~/.cache/zsh/zcompdump   # -C = skip security check (huge speedup)

##### PROMPT #####
zinit ice depth=1
zinit light romkatv/powerlevel10k
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

##### PLUGINS (LAZY LOADED) #####
zinit ice wait lucid
zinit light zsh-users/zsh-autosuggestions

zinit ice wait lucid
zinit light zsh-users/zsh-syntax-highlighting

zinit ice wait lucid
zinit light zsh-users/zsh-completions

# MUST load after compinit
zinit ice wait lucid
zinit light Aloxaf/fzf-tab

##### OMZ SNIPPETS (ONLY WHAT YOU USE) #####
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::command-not-found

zinit cdreplay -q

##### KEYBINDINGS #####
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

##### HISTORY (CORRECT & FAST) #####
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_FIND_NO_DUPS
setopt INC_APPEND_HISTORY

##### COMPLETION STYLING #####
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':fzf-tab:*' fzf-command fzf
zstyle ':fzf-tab:complete:*' fzf-preview 'ls --color=auto $realpath'

##### ENV VARS #####
export HOMEBREW_NO_ENV_HINTS=1
export RUSTFLAGS="-C linker=clang -C link-arg=-fuse-ld=lld"
export CFLAGS="clang -std=c99 -Wall -Werror"
export VIRTUAL_ENV_DISABLE_PROMPT=1
export CARGO_TARGET_DIR="$HOME/.cargo-target"

##### PATH (SAFE) #####
path_prepend() { [[ -d $1 ]] && path=($1 $path); }
path_prepend "$HOME/.local/bin"
path_prepend "/opt/homebrew/bin"
path_prepend "$HOME/.rustup/toolchains/stable-aarch64-apple-darwin/bin"

##### TOOL INTEGRATIONS #####
command -v fzf >/dev/null && eval "$(fzf --zsh)"
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"
command -v direnv >/dev/null && eval "$(direnv hook zsh)"

##### ALIASES #####
alias vim=nvim
alias c=clear
alias g=git
alias gs='git status'
alias gc='git commit -m'
alias gp='git push'

##### LS / TREE #####
if command -v eza >/dev/null; then
  alias ls='eza -l --icons --group-directories-first'
  alias la='eza -a --icons'
  alias ll='eza -l --icons'
  alias lt='eza -aT --icons'
  alias tree='eza --tree'
else
  alias ls='ls -lah'
fi

##### CAT / SEARCH #####
command -v bat >/dev/null && alias cat='bat -p'
command -v rg >/dev/null && alias grep=rg
command -v fd >/dev/null && alias find=fd

##### ARIA2 #####
if command -v aria2c >/dev/null; then
  alias aget='aria2c -x 16 -s 48 -k 4M --file-allocation=falloc'
  alias amag='aria2c --enable-dht --bt-max-peers=128 --seed-time=0'
fi


##### PROFILER OUTPUT (ONLY WHEN ENABLED) #####
# zprof
