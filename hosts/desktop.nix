# Desktop Configuration (with NVIDIA GPU, GUI apps)
{ config, pkgs, ... }:

{
  imports = [
    ../modules/gpu.nix       # NVIDIA GPU driver config
    ../modules/browsers.nix  # Chrome
  ];
  
  # Desktop-specific packages
  home.packages = with pkgs; [
    # Add any desktop-only packages here
  ];
}
