# Desktop Configuration (with NVIDIA GPU, GUI apps)
{ config, pkgs, ... }:

{
  imports = [
    ../../../modules/home/gpu.nix # NVIDIA GPU driver config
    ../../../modules/home/browsers.nix # Chrome
    ../../../modules/home/bitwarden.nix
  ];

  # Desktop-specific packages
  home.packages = with pkgs; [
    # Add any desktop-only packages here
  ];
}
