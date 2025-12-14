{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    
    settings = {
      # ── MONITORS ──
      monitor = [
        "eDP-1, preferred, auto, 1.25"
        "Virtual-1, 1920x1080@60, auto, 1"
      ];

      # ── MY PROGRAMS ──
      "$terminal" = "ghostty"; # User requested Ghostty
      "$fileManager" = "thunar";
      "$menu" = "rofi -show drun";

      # ── AUTOSTART ──
      # exec-once = "~/.config/hypr/scripts/waybar_watcher.sh &"; # Disabled - likely not needed with native setup or needs porting
      "exec-once" = [
        "waybar"
        "dunst"
        "swww init"
        # "hyprctl dispatch exec '[workspace 9 silent] firefox'" # Optional auto-launch
      ];

      # ── ENVIRONMENT VARIABLES ──
      env = [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
        "XDG_CURRENT_DESKTOP,Hyprland"
      ];

      # ── LOOK AND FEEL ──
      general = {
        gaps_in = 5;
        gaps_out = 20;
        border_size = 2;
        "col.active_border" = "rgba(61afefff)";
        "col.inactive_border" = "rgba(444444ff)";
        resize_on_border = false;
        allow_tearing = false;
        layout = "dwindle";
      };

      decoration = {
        rounding = 1;
        
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };
        
        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };
      };

      animations = {
        enabled = true;
        bezier = [
          "easeOutQuint,0.23,1,0.32,1"
          "easeInOutCubic,0.65,0.05,0.36,1"
          "linear,0,0,1,1"
          "almostLinear,0.5,0.5,0.75,1.0"
          "quick,0.15,0,0.1,1"
        ];
        animation = [
          "global, 1, 3, default" # Global speedup
          "border, 1, 2, easeOutQuint"
          "windows, 1, 2, easeOutQuint"
          "windowsIn, 1, 2, easeOutQuint, popin 87%"
          "windowsOut, 1, 2, linear, popin 87%"
          "fadeIn, 1, 1, almostLinear"
          "fadeOut, 1, 1, almostLinear"
          "fade, 1, 1, quick"
          "layers, 1, 2, easeOutQuint"
          "layersIn, 1, 2, easeOutQuint, fade"
          "layersOut, 1, 1.5, linear, fade"
          "fadeLayersIn, 1, 1, almostLinear"
          "fadeLayersOut, 1, 1, almostLinear"
          "workspaces, 1, 1.5, almostLinear, fade"
          "workspacesIn, 1, 1, almostLinear, fade"
          "workspacesOut, 1, 1.5, almostLinear, fade"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      master = {
        new_status = "master";
      };

      misc = {
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
      };

      ecosystem = {
        no_update_news = true;
      };

      # ── INPUT ──
      input = {
        kb_layout = "us"; # Default to US, user can change if needed
        follow_mouse = 1;
        sensitivity = 0;
        touchpad = {
          natural_scroll = true;
        };
      };

      # ── KEYBINDINGS ──
      "$mainMod" = "SUPER";
      "$altMod" = "ALT";

      bind = [
        # Apps
        "$altMod, T, exec, $terminal"
        # "$altMod, B, exec, firefox" # Removed - Firefox not installed
        "$altMod, F, exec, $fileManager"
        "$altMod, W, killactive,"
        "$altMod, V, togglefloating,"
        "$altMod, P, pseudo," # dwindle
        "$altMod, J, togglesplit," # dwindle
        "$altMod, SPACE, exec, $menu"

        # Move focus
        "$altMod, left, movefocus, l"
        "$altMod, right, movefocus, r"
        "$altMod, up, movefocus, u"
        "$altMod, down, movefocus, d"

        # Screenshot (requires grim + slurp)
        "$altMod, P, exec, grim -g \"$(slurp)\" - | wl-copy"
        
        # Workspaces
        "$altMod, 1, workspace, 1"
        "$altMod, 2, workspace, 2"
        "$altMod, 3, workspace, 3"
        "$altMod, 4, workspace, 4"
        "$altMod, 9, workspace, 9"

        "$mainMod, 1, movetoworkspace, 1"
        "$mainMod, 2, movetoworkspace, 2"
        "$mainMod, 3, movetoworkspace, 3"
        "$mainMod, 4, movetoworkspace, 4"
        "$mainMod, 9, movetoworkspace, 9"

        "$mainMod, S, togglespecialworkspace, magic"
        "$mainMod SHIFT, S, movetoworkspace, special:magic"
      ];

      bindm = [
        "$altMod, mouse:272, movewindow"
        "$altMod, mouse:273, resizewindow"
      ];
      
      bindel = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86MonBrightnessUp, exec, brightnessctl s 10%+"
        ", XF86MonBrightnessDown, exec, brightnessctl s 10%-"
      ];

      bindl = [
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
      ];
    };
  };

  # Dependencies
  home.packages = with pkgs; [
    swww        # Wallpaper daemon
    dunst       # Notification daemon
    libnotify   # Notification client
    waybar      # Status bar
    rofi        # App launcher
    grim        # Screenshot
    slurp       # Screenshot selection
    wl-clipboard # Clipboard
    xfce.thunar # File manager (as used in config)
    brightnessctl # Brightness control
    playerctl     # Media control
  ];
}
