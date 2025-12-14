{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "max";
  home.homeDirectory = "/home/max";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # Packages from src/dotfiles/tasks/packages.py
    git
    zsh
    stow
    curl
    neovim
    
    # Arch specific (base-devel) is usually system-level, skipping here unless requested.
    # Debian specific (build-essential, etc) is usually system-level.
    
    # Utilities
    ripgrep
    fd
    jq
    tree
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/max/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    # Config from src/dotfiles/tasks/git.py
    # Using 'settings' instead of deprecated options
    
    settings = {
      user = {
        name = "Max Noller"; # Assumed from path
        email = "max@example.com"; # Placeholder
      };
      init = {
        defaultBranch = "main";
      };
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # Source existing config
    # initExtra is deprecated, using initContent
    initContent = ''
      # Explicitly add Nix profile bin to PATH for Home Manager
      export PATH="$HOME/.nix-profile/bin:$PATH"

      # Source Home Manager session variables
      if [ -e $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh ]; then 
        . $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh
      fi

      # Source existing .zshrc from config/zsh/
      if [ -f ${config.home.homeDirectory}/dotfiles/config/zsh/.zshrc ]; then
        source ${config.home.homeDirectory}/dotfiles/config/zsh/.zshrc
      fi
      
      # Prepare p10k
      if [ -f ${config.home.homeDirectory}/dotfiles/config/zsh/.p10k.zsh ]; then
        source ${config.home.homeDirectory}/dotfiles/config/zsh/.p10k.zsh
      fi
    '';
  };

  programs.tmux = {
    enable = true;
    # Source existing config
    extraConfig = ''
      source-file ${config.home.homeDirectory}/dotfiles/config/tmux/.tmux.conf
    '';
  };

  # Neovim configuration
  # Symlinking ~/.config/nvim to config/nvim/.config/nvim
  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/nvim/.config/nvim";
  };
}
