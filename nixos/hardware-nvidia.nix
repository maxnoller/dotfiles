# NVIDIA Hardware Configuration
# Use this on real hardware with NVIDIA GPU.
# Replace hardware-vm.nix import with this + hardware-configuration.nix

{ config, lib, pkgs, ... }:

{
  # OpenGL (driSupport is now automatic in nixpkgs-unstable)
  hardware.graphics = {
    enable = true;
    enable32Bit = true;  # For Steam/32-bit games
  };

  # NVIDIA driver
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    # Modesetting is required for Wayland
    modesetting.enable = true;

    # Use the stable driver (recommended)
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    # Alternatives:
    # package = config.boot.kernelPackages.nvidiaPackages.beta;
    # package = config.boot.kernelPackages.nvidiaPackages.production;

    # Power management (try enabling if you have suspend issues)
    powerManagement.enable = false;
    powerManagement.finegrained = false;

    # Open-source kernel module (for RTX 30+ series, experimental)
    # Set to true if you have issues with the proprietary module
    open = false;

    # nvidia-settings GUI
    nvidiaSettings = true;
  };

  # Kernel parameters for NVIDIA
  boot.kernelParams = [
    "nvidia-drm.modeset=1"  # Required for Wayland
  ];
}
