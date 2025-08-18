
{ config, pkgs, ... }:

{
  home.username = "gourav";
  home.homeDirectory = "/Users/gourav";

  # Required for home-manager to know defaults schema
  home.stateVersion = "24.05"; # match your HM version (check with: home-manager --version)

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    # Core tools
    eza
    bat
    fd
    ripgrep
    zoxide
    starship
    fastfetch
    fzf

    # NeoVim
    neovim

    # Media / Downloads
    yt-dlp
    mpv
    aria2
    wget

    # Dev tools
    gcc
    gnumake
    python3
    rustup
    # optional:
    # haskellPackages.ghcup
    # platformio
  ];

  programs.starship.enable = true;

  programs.fish = {
    enable = true;
    shellInit = ''
      source $HOME/dotfiles/config.fish
      set -x MANPAGER bat
      set -gx PATH $HOME/.local/bin $PATH
      set fish_greeting
    '';
  };
}

okay edit it
