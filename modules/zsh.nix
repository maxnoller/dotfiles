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
      if [[ $SHLVL -eq 1 && -z "$INSIDE_EMACS" && -z "$VSCODE_INJECTION" ]]; then
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

  # Starship prompt (replaces p10k)
  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[✗](bold red)";
      };
      
      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
        style = "bold cyan";
      };
      
      git_branch = {
        symbol = " ";
        style = "bold purple";
      };
      
      git_status = {
        style = "bold red";
      };
      
      nix_shell = {
        symbol = " ";
        style = "bold blue";
      };
      
      nodejs = {
        symbol = " ";
      };
      
      python = {
        symbol = " ";
      };
      
      rust = {
        symbol = " ";
      };
      
      package = {
        disabled = true;
      };
    };
  };

  # FZF fuzzy finder
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "fd --type f --hidden --follow --exclude .git";
    defaultOptions = [
      "--height 40%"
      "--layout=reverse"
      "--border"
      "--preview 'head -100 {}'"
    ];
    colors = {
      "bg+" = "#313244";
      "bg" = "#1e1e2e";
      "spinner" = "#f5e0dc";
      "hl" = "#f38ba8";
      "fg" = "#cdd6f4";
      "header" = "#f38ba8";
      "info" = "#cba6f7";
      "pointer" = "#f5e0dc";
      "marker" = "#f5e0dc";
      "fg+" = "#cdd6f4";
      "prompt" = "#cba6f7";
      "hl+" = "#f38ba8";
    };
  };
}
