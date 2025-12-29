{self, ...}: {
  # Enable Touch ID authentication for sudo
  security.pam.services.sudo_local.touchIdAuth = true;

  system = {
    # nix-darwin state version (do not change once set)
    stateVersion = 6;

    # Embed current git revision into the system config
    configurationRevision = self.rev or self.dirtyRev or null;

    # Disable macOS startup sound
    startup.chime = false;

    # Keyboard behavior
    keyboard = {
      remapCapsLockToControl = true;
    };

    defaults = {
      # Reduce system-wide motion effects
      universalaccess.reduceMotion = true;

      # Login screen restrictions
      loginwindow = {
        GuestEnabled = false;
        DisableConsoleAccess = true;
      };

      # Dock behavior and gestures
      dock = {
        autohide = true;
        mru-spaces = false;
        show-recents = false;
        showDesktopGestureEnabled = true;
        showLaunchpadGestureEnabled = true;
      };

      # Screenshot behavior
      screencapture = {
        location = "~/Screenshots";
        type = "jpg";
        include-date = false;
      };

      # Trackpad preferences
      trackpad = {
        TrackpadRightClick = true;
        TrackpadThreeFingerDrag = false;
        Clicking = true;
      };

      # Finder visibility and UI tweaks
      finder = {
        AppleShowAllFiles = true;
        AppleShowAllExtensions = true;
        _FXShowPosixPathInTitle = true;
        ShowPathbar = true;
        ShowStatusBar = true;
      };

      # Global keyboard, text, and animation behavior
      NSGlobalDomain = {
        InitialKeyRepeat = 18;
        KeyRepeat = 2;
        NSAutomaticSpellingCorrectionEnabled = false;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticWindowAnimationsEnabled = false;
      };

      # Restart UI services so defaults apply immediately
      activationScripts.postActivation.text = ''
        killall Finder Dock SystemUIServer || true
      '';
    };
  };
}
