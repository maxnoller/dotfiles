{ config, pkgs, ... }:

{
  # Configure GPU access for non-NixOS (pure - no --impure needed)
  # This creates /run/opengl-driver with proper NVIDIA libraries
  #
  # ⚠️  IMPORTANT: Update version and hash when upgrading NVIDIA drivers!
  # 
  # To get the hash for a new version:
  #   nix store prefetch-file https://download.nvidia.com/XFree86/Linux-x86_64/<VERSION>/NVIDIA-Linux-x86_64-<VERSION>.run
  #
  # After updating, run:
  #   home-manager switch --flake .#max
  #   sudo /nix/store/.../non-nixos-gpu-setup  (path shown in activation output)
  
  targets.genericLinux.gpu.nvidia = {
    enable = true;
    version = "550.163.01";
    sha256 = "sha256-74FJ9bNFlUYBRen7+C08ku5Gc1uFYGeqlIh7l1yrmi4=";
  };
}
