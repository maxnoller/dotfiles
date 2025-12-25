[
  {
    layer = "top";
    position = "top";
    margin-top = 12;
    margin-bottom = -8;
    # width = 2010; # Removed to allow dynamic width
    height = 34;

    modules-left = [
      "clock"
      "network"
      # "bluetooth" # Disabled as requested
    ];

    modules-center = [
      "hyprland/workspaces"
    ];

    modules-right = [
      "battery"
      "pulseaudio"
      "backlight"
      "tray"
    ];

    # ── Clock ──
    clock = {
      tooltip-format = "{calendar}";
      format-alt = "  {:%a, %d %b %Y}";
      format = "[   {:%I:%M %p} ]";
    };

    # ── Network ──
    network = {
      format-wifi = "{icon}";
      format-icons = [
        "[ 󰤯 ]"
        "[ 󰤟 ]"
        "[ 󰤢 ]"
        "[ 󰤥 ]"
        "[ 󰤨 ]"
      ];
      format-ethernet = "󰀂";
      format-alt = "󱛇";
      format-disconnected = "󰖪";
      tooltip-format-wifi = "{icon} {essid}\n⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
      tooltip-format-ethernet = "󰀂  {ifname}\n⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
      tooltip-format-disconnected = "Disconnected";
      on-click = "nm-connection-editor";
      interval = 5;
    };

    # ── Bluetooth ──
    bluetooth = {
      format = "{icon}";
      format-icons = {
        enabled = "[  ]";
        disabled = "[ 󰂲 ]";
      };
      tooltip-format = "Bluetooth is {status}";
    };

    # ── Battery ──
    battery = {
      format = "{icon}  {capacity}%";
      format-icons = {
        charging = [
          "󰢜"
          "󰂆"
          "󰂇"
          "󰂈"
          "󰢝"
          "󰂉"
          "󰢞"
          "󰂊"
          "󰂋"
          "󰂅"
        ];
        default = [
          "󰁺"
          "󰁻"
          "󰁼"
          "󰁽"
          "󰁾"
          "󰁿"
          "󰂀"
          "󰂁"
          "󰂂"
          "󰁹"
        ];
      };
      format-full = "Charged ";
      interval = 5;
      states = {
        warning = 20;
        critical = 10;
      };
      tooltip = true;
    };

    # ── Pulseaudio ──
    pulseaudio = {
      format = "{icon} {volume}%";
      format-muted = "󰝟 Muted";
      format-icons = {
        default = [
          "󰕿"
          "󰖀"
          "󰕾"
        ];
      };
      on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
      on-scroll-up = "wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+";
      on-scroll-down = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
      scroll-step = 5;
    };

    # ── Backlight ──
    backlight = {
      format = "󰛨  {percent}%";
      format-icons = [
        "󰃞"
        "󰃟"
        "󰃠"
        "󰃝"
        "󰃜"
        "󰃛"
      ];
    };

    # ── Tray ──
    tray = {
      icon-size = 21;
      spacing = 10;
    };
  }
]
