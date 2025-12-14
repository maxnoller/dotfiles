{ config, pkgs, inputs, ... }:

{
  home.username = "max";
  home.homeDirectory = "/home/max";
  home.stateVersion = "24.05";
  
  # Enable generic Linux integration
  targets.genericLinux.enable = true;

  imports = [
    ./modules/gpu.nix      # NVIDIA GPU driver config
    ./modules/zsh.nix
    ./modules/git.nix
    ./modules/tmux.nix
    ./modules/tools.nix
    ./modules/claude.nix
    ./modules/fastfetch.nix
    ./modules/browsers.nix
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };
  
  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/nvim/.config/nvim";
  };

  programs.home-manager.enable = true;
}
