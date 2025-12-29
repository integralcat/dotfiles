{...}: {
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
      upgrade = true;
      # zap: Uninstalls unused casks, cache files, launch agents
      cleanup = "zap";
    };

    caskArgs.no_quarantine = true;
    global.brewfile = true;

    # homebrew is best for GUI apps
    # nixpkgs is best for CLI tools
    casks = [
      # OS enhancements
      "maccy"
      "rectangle"
      "hiddenbar"
      "appcleaner"

      # dev
      "kitty"
      "zed"

      # messaging
      "discord"
      "whatsapp"

      # other
      "obsidian"
      "protonvpn"
      "spotify"
      "notion"
      "chrome"
      "zen"
      "iina"
	  "blender"
    ];
    brews = [
      # Brew Packages
    ];
    taps = [
    ];
  };
}
