{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    
    # Oh My Zsh
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "docker"
        "tmux"
      ];
    };

    # Additional Plugins
    plugins = [
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.zsh-syntax-highlighting;
        file = "share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
      }
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];

    # Init Config
    initContent = ''
      # Source Nix profile if it exists (critical for usage of nix outside of nixos)
      if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then . $HOME/.nix-profile/etc/profile.d/nix.sh; fi
      
      # Source p10k config
      if [ -f ${config.home.homeDirectory}/dotfiles/config/zsh/.p10k.zsh ]; then
        source ${config.home.homeDirectory}/dotfiles/config/zsh/.p10k.zsh
      fi
      
      # Run fastfetch on new interactive shells (but not in nested shells or scripts)
      if [[ $SHLVL -eq 1 && -z "$INSIDE_EMACS" && -z "$VSCODE_INJECTION" ]]; then
        fastfetch
      fi
    '';

    # Environment Variables
    sessionVariables = {
       # pnpm
       PNPM_HOME = "${config.home.homeDirectory}/.local/share/pnpm";
       # bun
       BUN_GLOBAL_BIN = "${config.home.homeDirectory}/.bun/bin";
       # moon
       MOON_BIN_DIR = "${config.home.homeDirectory}/.moon/bin";
       # proto
       PROTO_HOME = "${config.home.homeDirectory}/.proto";
       
       # Update PATH to include these
       PATH = "$HOME/.nix-profile/bin:$PNPM_HOME:$BUN_GLOBAL_BIN:$MOON_BIN_DIR:$PROTO_HOME/shims:$PROTO_HOME/bin:$PATH";
    };

    # Aliases
    shellAliases = {
      vim = "nvim";
      vi = "nvim";
      v = "nvim";
      python = "python3";
      pip = "pip3";
      ":q" = "exit";
      ll = "ls -la";
      la = "ls -la";
      l = "ls -l";
    };
  };
}
