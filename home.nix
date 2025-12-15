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
    CHROME_BIN = "google-chrome-stable";
    PUPPETEER_EXECUTABLE_PATH = "google-chrome-stable";
    # Bitwarden SSH Agent (see: https://bitwarden.com/help/ssh-agent/)
    SSH_AUTH_SOCK = "${config.home.homeDirectory}/.bitwarden-ssh-agent.sock";
  };
  
  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/nvim/.config/nvim";
  };

  programs.home-manager.enable = true;
}
