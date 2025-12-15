{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Developer Tools
    bun
    nodejs
    uv
    pnpm
    
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
    categories = [ "System" "TerminalEmulator" ];
    icon = "com.mitchellh.ghostty";
    comment = "A terminal emulator";
    settings = {
      StartupNotify = "true";
      StartupWMClass = "com.mitchellh.ghostty";
      DBusActivatable = "false";  # Fix for non-NixOS
      Keywords = "terminal;tty;pty;";
    };
  };
}
