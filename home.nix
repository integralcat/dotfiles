{ pkgs, ... }:

{
  home.username = "gourav";
  home.homeDirectory =
    if pkgs.stdenv.isDarwin then "/Users/gourav" else "/home/gourav";

  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    eza
    bat
    fd
    ripgrep
  ];

  programs.zsh.enable = false;
  programs.fish.enable = false;
}
