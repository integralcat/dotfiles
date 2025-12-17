{ config, pkgs, ... }:

{
  home.username = "gourav";
  home.homeDirectory = "/Users/gourav";

  home.stateVersion = "25.11";
  home.enableNixpkgsReleaseCheck = false;

  home.packages = with pkgs; [
    # core tools
    aria2
    bat
    dust
    eza
    fd
    fzf
    ripgrep
    zoxide
	bat-extras.batman

    # dev
    neovim
    tmux
    hyperfine
    bear
    silicon

    # rust / python
    rustup
    uv

    # misc
    starship
    tealdeer
  ];

  programs.home-manager.enable = true;

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  programs.fish.enable = false;

  # disable others explicitly if you want
  programs.zsh.enable = false;
  programs.bash.enable = false;
}
