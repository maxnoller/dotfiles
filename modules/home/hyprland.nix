{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;

    # Hyprland plugins
    plugins = [
      pkgs.hyprlandPlugins.hyprbars
      pkgs.hyprlandPlugins.hyprexpo
    ];

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
      "exec-once" = [
        "waybar"
        "swaync" # Notification center (replaces dunst)
        "swww init"
        # Clipboard history
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
      ];

      # ── ENVIRONMENT VARIABLES ──
      env = [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
        "XDG_CURRENT_DESKTOP,Hyprland"
        "NIXOS_OZONE_WL,1" # Electron uses Wayland
        "QT_QPA_PLATFORM,wayland" # Qt uses Wayland
        "SDL_VIDEODRIVER,wayland" # SDL uses Wayland
      ];

      # ── LOOK AND FEEL ──
      # NOTE: Colors are now managed by Stylix (nixos/stylix.nix)
      # We only keep layout and behavior settings here
      general = {
        gaps_in = 5;
        gaps_out = 20;
        border_size = 2;
        # Colors managed by Stylix
        resize_on_border = false;
        allow_tearing = false;
        layout = "dwindle";
      };

      decoration = {
        rounding = 8; # Slightly more rounded for modern look

        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };

        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          # Color managed by Stylix
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

      # ── PLUGIN SETTINGS ──
      "plugin:hyprbars" = {
        bar_height = 24;
        bar_color = "rgba(2E3440ff)";
        "col.text" = "rgba(ECEff4ff)";
        bar_text_font = "JetBrainsMono Nerd Font";
        bar_text_size = 10;
        bar_part_of_window = true;
        bar_precedence_over_border = true;
        hyprbars-button = [
          "rgba(BF616Aff), 12, 󰖭, hyprctl dispatch killactive"
          "rgba(EBCB8Bff), 12, 󰖰, hyprctl dispatch fullscreen 1"
          "rgba(A3BE8Cff), 12, 󰖯, hyprctl dispatch togglefloating"
        ];
      };

      "plugin:hyprexpo" = {
        columns = 3;
        gap_size = 5;
        bg_col = "rgba(2E3440ff)";
        workspace_method = "first 1";
        enable_gesture = true;
        gesture_fingers = 3;
        gesture_distance = 300;
        gesture_positive = true;
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
        "$altMod, O, pseudo," # dwindle (O for "organize")
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
        "$altMod, 5, workspace, 5"
        "$altMod, 6, workspace, 6"
        "$altMod, 7, workspace, 7"
        "$altMod, 8, workspace, 8"
        "$altMod, 9, workspace, 9"

        "$mainMod, 1, movetoworkspace, 1"
        "$mainMod, 2, movetoworkspace, 2"
        "$mainMod, 3, movetoworkspace, 3"
        "$mainMod, 4, movetoworkspace, 4"
        "$mainMod, 5, movetoworkspace, 5"
        "$mainMod, 6, movetoworkspace, 6"
        "$mainMod, 7, movetoworkspace, 7"
        "$mainMod, 8, movetoworkspace, 8"
        "$mainMod, 9, movetoworkspace, 9"

        # Fullscreen
        "$altMod, M, fullscreen, 0"

        # Lock Screen
        "$mainMod, L, exec, hyprlock"

        # Screenshot (Hyprshot)
        "$mainMod SHIFT, S, exec, hyprshot -m region"
        "$mainMod SHIFT, W, exec, hyprshot -m window"
        "$mainMod SHIFT, P, exec, hyprshot -m output"

        # Session (Wlogout)
        "$mainMod, Escape, exec, wlogout"

        # Workspace Overview (Hyprexpo)
        "$mainMod, grave, hyprexpo:expo, toggle"

        # Notification Center (SwayNC)
        "$mainMod, N, exec, swaync-client -t -sw"

        # Clipboard History (Cliphist)
        "$mainMod, V, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy"

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
    swww # Wallpaper daemon
    libnotify # Notification client
    waybar # Status bar
    rofi # App launcher
    grim # Screenshot
    slurp # Screenshot selection
    wl-clipboard # Clipboard
    xfce.thunar # File manager (as used in config)
    brightnessctl # Brightness control
    playerctl # Media control
  ];
}
