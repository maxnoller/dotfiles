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
  ];

  # NOTE: No Ghostty desktop entry workaround needed on NixOS!
  # DBusActivatable works correctly on NixOS.
}
