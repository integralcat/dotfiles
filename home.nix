
{ config, pkgs, ... }:

{
  home.username = "gourav";
  home.homeDirectory = "/Users/gourav";

  # Required for home-manager to know defaults schema
  home.stateVersion = "24.05"; # match your HM version (check with: home-manager --version)

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    # Core tools
    fd
    bat
    fzf
    eza
    tldr
    fish
    zoxide
    openssh
    ripgrep
    starship
    fastfetch

    # NeoVim
    neovim

    # Media / Downloads
    yt-dlp
    aria2
    wget

    # Dev tools
    python312
    rustup
  ];

  programs.starship.enable = true;

}
