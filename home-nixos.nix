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
    ./modules/neovim.nix  # nixCats-managed Neovim
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
    # Bitwarden SSH Agent (see: https://bitwarden.com/help/ssh-agent/)
    SSH_AUTH_SOCK = "${config.home.homeDirectory}/.bitwarden-ssh-agent.sock";
  };
  
  # NOTE: nvim config is now managed by nixCats in modules/neovim.nix

  programs.home-manager.enable = true;
}
