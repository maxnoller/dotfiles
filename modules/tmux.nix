{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    
    # Prefix key (Ctrl-Space)
    prefix = "C-Space";
    
    # No delay for escape sequences
    escapeTime = 0;
    
    # Terminal settings
    terminal = "tmux-256color";
    
    # Vi mode for copy
    keyMode = "vi";
    
    # Start window and pane numbering at 1
    baseIndex = 1;
    
    # History limit
    historyLimit = 50000;
    
    # Enable mouse
    mouse = true;
    
    # Aggressive resize
    aggressiveResize = true;
    
    # Plugins
    plugins = with pkgs.tmuxPlugins; [
      sensible
      yank
      vim-tmux-navigator
      {
        plugin = resurrect;
        extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      }
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '60'
        '';
      }
    ];

    extraConfig = ''
      # Blue monochrome theme
      set -g status-style "bg=#0f0f1a,fg=#6db3f2"
      set -g pane-border-style "fg=#1a1a2e"
      set -g pane-active-border-style "fg=#4a90d9"
      set -g message-style "bg=#1a1a2e,fg=#6db3f2"
      set -g mode-style "bg=#4a90d9,fg=#0f0f1a"
      
      # Window status
      set -g window-status-format "#[fg=#5c5c70] #I:#W "
      set -g window-status-current-format "#[fg=#6db3f2,bold] #I:#W "
      
      # Enable true color support
      set -ga terminal-overrides ",*256col*:Tc"
      
      # Automatically renumber windows when one is closed
      set -g renumber-windows on
      
      # Pane base index
      setw -g pane-base-index 1
      
      #############################
      # Clipboard Integration
      #############################
      if-shell "command -v xclip" \
          "bind-key -T copy-mode-vi y send -X copy-pipe-and-cancel 'xclip -selection clipboard -in'" \
          "if-shell 'command -v wl-copy' \
              'bind-key -T copy-mode-vi y send -X copy-pipe-and-cancel wl-copy'"
      
      #############################
      # Key Bindings
      #############################
      # Splits that keep the current pane's directory
      unbind %
      bind '\' split-window -h -c "#{pane_current_path}"
      unbind '"'
      bind - split-window -v -c "#{pane_current_path}"
      
      # Resize panes with Alt+Arrow keys
      unbind C-h
      unbind C-j
      unbind C-k
      unbind C-l
      bind -r M-Left resize-pane -L 5
      bind -r M-Down resize-pane -D 5
      bind -r M-Up resize-pane -U 5
      bind -r M-Right resize-pane -R 5
      
      # Vim-style pane navigation
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
      
      # Swap Windows using Ctrl+Shift+Left/Right
      bind-key -n C-S-Left swap-window -t -1 \; previous-window
      bind-key -n C-S-Right swap-window -t +1 \; next-window
      
      #############################
      # Status Bar Configuration
      #############################
      set-option -g status-interval 15
      set-option -g status-justify centre
      set-option -g status-position top
      set-option -g status-left " 󰄛 "
      set-option -g status-right-length 50
      
      # Modern options
      set-option -g extended-keys on
      set-option -g focus-events on
      set-option -g allow-passthrough on
      set-option -g set-clipboard on
      
      # Reload configuration shortcut
      unbind r
      bind r source-file ~/.config/tmux/tmux.conf \; display-message "Tmux config reloaded!"
    '';
  };
}
