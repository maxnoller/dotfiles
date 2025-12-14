{ config, pkgs, inputs, ... }:

{
  home.username = "max";
  home.homeDirectory = "/home/max";
  home.stateVersion = "24.05";
  
  # Enable generic Linux integration (for non-NixOS)
  targets.genericLinux.enable = true;

  # Shared modules (used by all machines)
  imports = [
    ./modules/zsh.nix
    ./modules/git.nix
    ./modules/tmux.nix
    ./modules/tools.nix
    ./modules/claude.nix
    ./modules/fastfetch.nix
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };
  
  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/nvim/.config/nvim";
  };

  programs.home-manager.enable = true;
}
