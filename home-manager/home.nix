{
  config,
  pkgs,
  ...
}: {
  home.username = "gourav";
  home.homeDirectory = "/Users/gourav";

  home.stateVersion = "25.11";
  home.enableNixpkgsReleaseCheck = false;

  home.packages = with pkgs; [
    # core
    aria2
    bat
    bat-extras.batman
    dust
    eza
    fd
	stow
    fzf
    gh
    ripgrep
    zoxide
    glow # Markdown Reader
    inetutils # telnet etc by GNU.
    tealdeer # tldr (rust)

    # dev
    fish
    neovim
    nodejs_24
    tmux
    hyperfine
    bear
    silicon

    # alejandra
    # nil

    # ai
    opencode

    # lang
    rustup
    uv

    # shell
    starship
  ];

  programs.home-manager.enable = true;

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  programs.fish.enable = false;
  programs.zsh.enable = false;
  programs.bash.enable = false;
}
