# NixOS Home Manager Configuration
# This variant is for NixOS systems - no genericLinux workarounds needed
{ config, pkgs, inputs, ... }:

{
  home.username = "max";
  home.homeDirectory = "/home/max";
  home.stateVersion = "24.05";
  
  # NOTE: No targets.genericLinux.enable - not needed on NixOS!

  # Shared modules (used by all machines)
  imports = [
    ./modules/zsh.nix
    ./modules/git.nix
    ./modules/tmux.nix
    ./modules/tools-nixos.nix  # NixOS variant without workarounds
    ./modules/claude.nix
    ./modules/fastfetch.nix
    # ./modules/browsers.nix     # Disabled to match remote setup purity
    
    # Hyprland Desktop Environment
    ./modules/hyprland.nix
    ./modules/waybar.nix
    ./modules/rofi.nix
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    CHROME_BIN = "google-chrome-stable";
    PUPPETEER_EXECUTABLE_PATH = "google-chrome-stable";
  };
  
  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/nvim/.config/nvim";
  };

  programs.home-manager.enable = true;
}
