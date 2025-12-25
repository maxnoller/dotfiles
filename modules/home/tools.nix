{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Developer Tools
    bun
    nodejs
    uv
    pnpm
    moon
    proto
    kubernetes-helm
    kubectl
    fluxcd

    # Utilities
    ripgrep
    fd
    jq
    tree
    curl

    # Security / Password Management
    bitwarden-desktop
    bitwarden-cli
    # Network / VPN
    tailscale

    # Terminal
    ghostty

    # Communication & Media
    spotify
    discord
  ];

  # Fix Ghostty desktop file for non-NixOS (disable DBusActivatable)
  # Must use same name as original to override it
  xdg.desktopEntries."com.mitchellh.ghostty" = {
    name = "Ghostty";
    genericName = "Terminal";
    exec = "${pkgs.ghostty}/bin/ghostty";
    terminal = false;
    categories = [
      "System"
      "TerminalEmulator"
    ];
    icon = "com.mitchellh.ghostty";
    comment = "A terminal emulator";
    settings = {
      StartupNotify = "true";
      StartupWMClass = "com.mitchellh.ghostty";
      DBusActivatable = "false"; # Fix for non-NixOS
      Keywords = "terminal;tty;pty;";
    };
  };

  xdg.desktopEntries."spotify" = {
    name = "Spotify";
    genericName = "Music Player";
    exec = "${pkgs.spotify}/bin/spotify %U";
    terminal = false;
    categories = [
      "Audio"
      "Music"
      "Player"
      "AudioVideo"
    ];
    icon = "spotify-client";
    comment = "Music streaming service";
    settings = {
      StartupNotify = "true";
      StartupWMClass = "spotify";
      DBusActivatable = "false";
    };
  };

  xdg.desktopEntries."discord" = {
    name = "Discord";
    genericName = "Internet Messenger";
    exec = "${pkgs.discord}/bin/discord";
    terminal = false;
    categories = [
      "Network"
      "InstantMessaging"
    ];
    icon = "discord";
    comment = "All-in-one voice and text chat";
    settings = {
      StartupNotify = "true";
      StartupWMClass = "discord";
      DBusActivatable = "false";
    };
  };
}
