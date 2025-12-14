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
    ];

    # Init Config
    initContent = ''
      # Source Nix profile if it exists (critical for usage of nix outside of nixos)
      if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then . $HOME/.nix-profile/etc/profile.d/nix.sh; fi
      
      # Run fastfetch on new interactive shells (but not in nested shells or scripts)
      if [[ -z "$INSIDE_EMACS" && -z "$VSCODE_INJECTION" ]]; then
        fastfetch
      fi
    '';

    # Environment Variables
    sessionVariables = {
       PNPM_HOME = "${config.home.homeDirectory}/.local/share/pnpm";
       BUN_GLOBAL_BIN = "${config.home.homeDirectory}/.bun/bin";
       MOON_BIN_DIR = "${config.home.homeDirectory}/.moon/bin";
       PROTO_HOME = "${config.home.homeDirectory}/.proto";
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
      # Update alias
      hm-update = "cd ~/dotfiles && nix flake update && home-manager switch --flake .#max";
    };
  };

  # Starship prompt - minimal, blue monochrome
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      
      format = "$directory$git_branch$character ";
      
      character = {
        success_symbol = "[❯](bold blue)";
        error_symbol = "[❯](bold red)";
      };
      
      directory = {
        truncation_length = 2;
        style = "bold bright-blue";
      };
      
      git_branch = {
        symbol = "";
        format = "[$branch]($style) ";
        style = "blue";
      };
    };
  };

  # FZF - blue/black theme
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "fd --type f --hidden --follow --exclude .git";
    defaultOptions = [
      "--height 40%"
      "--layout=reverse"
      "--border"
    ];
    colors = {
      "bg+" = "#1a1a2e";
      "bg" = "#0f0f1a";
      "spinner" = "#4a90d9";
      "hl" = "#5c9fd4";
      "fg" = "#a0a0b0";
      "header" = "#4a90d9";
      "info" = "#5c9fd4";
      "pointer" = "#6db3f2";
      "marker" = "#6db3f2";
      "fg+" = "#d0d0e0";
      "prompt" = "#4a90d9";
      "hl+" = "#6db3f2";
    };
  };
}
