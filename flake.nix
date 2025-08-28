{
  description = "Gourav's user packages flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; # track latest unstable nixpkgs
  };

  outputs = { self, nixpkgs }:
    let
      system = "aarch64-darwin"; # since you're on macOS; change to aarch64-darwin if Apple Silicon
      pkgs = import nixpkgs { inherit system; };
    in
    {
      packages.${system}.user-packages = pkgs.buildEnv {
        name = "user-packages";
        paths = with pkgs; [
          # Modern replacements / general CLI
          eza # modern 'ls'
          bat # cat with syntax highlighting
          fd # fast 'find'
          gh # github cli
          ripgrep # fast 'grep'
          zoxide # smarter cd
          mosh # mobile-friendly SSH replacement
          llvm # LLVM toolchain (compiler infra)
          fastfetch # neofetch alternative for system info
          fzf # fuzzy finder
          jq # JSON processor
          tmux # terminal multiplexer
          duf # disk usage/free space viewer
          dust # du alternative (disk usage)
          rsync # fast file sync/copy
          tldr # simplified man pages
          hyperfine # benchmarking tool
          imagemagick # Image/PDF manipultion tool
          openssh # SSH client/server
          iperf3 # network benchmarking tool

          # Networking & downloads
          aria2 # advanced downloader
          wget # classic downloader
          yt-dlp # youtube-dl fork

          # Dev tools
          neovim # text editor
          uv # Python package manager / installer
          python3 # Python interpreter
          rustup # Rust toolchain installer

          # Shell
          fish # friendly interactive shell
        ];
      };
    };
}
