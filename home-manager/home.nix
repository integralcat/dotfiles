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
	gh # github-cli
    ripgrep
    zoxide
	bat-extras.batman
	# dnsdomainname ftp hostname ifconfig logger ping ping6 rcp rexec rlogin rsh talk telnet tftp traceroute whois
	inetutils 

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
