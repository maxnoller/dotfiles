# NixOS System Configuration
# This is the main system-level configuration for NixOS.
# For VM testing: nixos-rebuild build-vm --flake .#desktop-vm
# For real install: nixos-rebuild switch --flake .#desktop-nixos

{ config, pkgs, ... }:

{
  imports = [
    ../../../modules/nixos/stylix.nix # System-wide theming
  ];

  # Hardware modules are passed via flake.nix extraModules
  # - VM testing: hardware-vm.nix
  # - Real install: hardware-nvidia.nix + hardware-configuration.nix

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "nixos-desktop";
  networking.networkmanager.enable = true;

  # Timezone and locale
  time.timeZone = "Europe/Berlin"; # Adjust to your timezone
  i18n.defaultLocale = "en_US.UTF-8";

  # Desktop Environment (Hyprland + SDDM)
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "where_is_my_sddm_theme";
    extraPackages = [ pkgs.where-is-my-sddm-theme ];
  };
  programs.hyprland.enable = true;
  programs.hyprland.xwayland.enable = true; # Allow running X11 apps

  # Audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # User account
  users.users.max = {
    isNormalUser = true;
    description = "Max";
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
    ];
    # Password for VM testing - change on real install!
    initialPassword = "nixos";
  };

  # Allow unfree packages (for NVIDIA, Steam, etc.)
  nixpkgs.config.allowUnfree = true;

  # Enable Nix flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # System packages (minimal - most go through Home Manager)
  environment.systemPackages = with pkgs; [
    vim
    git
    wget
    curl
  ];

  # Steam (system-level for proper integration)
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };

  # Gaming optimizations
  programs.gamemode.enable = true;

  # dconf (required for GTK themes to work properly)
  programs.dconf.enable = true;

  system.stateVersion = "24.05";
}
