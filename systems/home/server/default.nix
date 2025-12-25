# Server Configuration (no GPU, no GUI apps)
{ config, pkgs, ... }:

{
  # No GPU module - servers typically don't need GPU drivers
  # No browsers - headless servers don't need GUI apps

  # Server-specific packages
  home.packages = with pkgs; [
    # Add any server-only packages here
    # htop
    # ncdu
  ];
}
