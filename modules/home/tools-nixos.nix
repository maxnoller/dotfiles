# NixOS Tools Configuration
# This is the NixOS variant of tools.nix - no workarounds needed!
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
    # Network / VPN
    tailscale

    # Browsers
    vivaldi
    google-chrome

    # Customization & Widgets
    eww

    # Utilities
    hyprshot

    # "Cool" Rice Tools
    cava # Audio visualizer
    pipes-rs # Rust version of pipes.sh (faster)
    cbonsai # Terminal bonsai tree
    fastfetch # Modern system info (replaces neofetch)

    # Clipboard
    cliphist # Clipboard history manager

    # Communication & Media
    spotify
    discord

    # Fonts
    nerd-fonts.jetbrains-mono
  ];

  # NOTE: No Ghostty/Spotify/Discord desktop entry workarounds needed on NixOS!
  # DBusActivatable works correctly on NixOS.
}
