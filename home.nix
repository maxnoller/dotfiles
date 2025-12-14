{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "max";
  home.homeDirectory = "/home/max";

  # This value determines the Home Manager release that your configuration is
  # compatible with.
  home.stateVersion = "24.05";

  # Import Modules
  imports = [
    ./modules/zsh.nix
    ./modules/git.nix
    ./modules/tmux.nix
    ./modules/tools.nix
    ./modules/claude.nix
    ./modules/fastfetch.nix
  ];

  # Home Manager can also manage your environment variables specifically.
  home.sessionVariables = {
    EDITOR = "nvim";
  };
  
  # Neovim configuration (Symlink)
  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/nvim/.config/nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
