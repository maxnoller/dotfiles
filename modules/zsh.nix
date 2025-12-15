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
      
      # Force Bitwarden SSH Agent (overrides GNOME Keyring or other agents)
      export SSH_AUTH_SOCK="$HOME/.bitwarden-ssh-agent.sock"
      
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

  # Starship prompt - Nord theme
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      
      format = "$directory$git_branch$character ";
      
      character = {
        # Nord: nord8 cyan for success, nord11 red for errors
        success_symbol = "[❯](#88C0D0 bold)";
        error_symbol = "[❯](#BF616A bold)";
      };
      
      directory = {
        truncation_length = 2;
        # Nord: nord9 secondary blue
        style = "#81A1C1 bold";
      };
      
      git_branch = {
        symbol = "";
        format = "[$branch]($style) ";
        # Nord: nord7 cyan accent
        style = "#8FBCBB";
      };
    };
  };

  # FZF - Nord theme
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "fd --type f --hidden --follow --exclude .git";
    defaultOptions = [
      "--height 40%"
      "--layout=reverse"
      "--border"
    ];
    # Nord color palette
    colors = {
      "bg+" = "#3B4252";   # nord1
      "bg" = "#2E3440";    # nord0
      "spinner" = "#88C0D0"; # nord8
      "hl" = "#88C0D0";    # nord8
      "fg" = "#D8DEE9";    # nord4
      "header" = "#88C0D0"; # nord8
      "info" = "#81A1C1";  # nord9
      "pointer" = "#88C0D0"; # nord8
      "marker" = "#A3BE8C"; # nord14 green
      "fg+" = "#ECEFF4";   # nord6
      "prompt" = "#88C0D0"; # nord8
      "hl+" = "#8FBCBB";   # nord7
    };
  };
}
