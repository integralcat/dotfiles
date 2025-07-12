starship init fish | source

# Homebrew warning
export HOMEBREW_NO_ENV_HINTS=1

# Enable Nix in fish
if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
    bass source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
end

# === ALIASES ===
alias cls='clear'
alias ls='eza --sort type --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions'
alias reload='source ~/dotfiles/fish/config.fish'
alias kc='keychain'
alias helix='hx'
alias tree='eza --tree'
alias rm='rm'
alias cat='bat'
alias export='set -x VAR'
alias cd='z'
alias find='fd'
alias grep='rg'
alias man='batman'

zoxide init fish | source
# === KEYBINDINGS ===

# === Theme ===
set -g fish_color_autosuggestion '#999999'

# For FastFetch Image Setup
if test "$TERM" = xterm-kitty
    # Terminal is Kitty — supports graphics
    fastfetch --kitty-direct /Users/gourav/.config/fastfetch/shell_logo.png
else if status --is-interactive
    if test "$TERM_PROGRAM" != vscode
        fastfetch -l none
    end
end

cd ~/work/
