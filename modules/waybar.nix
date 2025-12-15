{ pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    style = ''
/* ──────────────────────────────────────────────────────────────────────────
   Nord Theme - Arctic, north-bluish color palette
   https://www.nordtheme.com/
   ────────────────────────────────────────────────────────────────────────── */

/* === Base Waybar Styling ================================================= */

* {
  border: none;
  border-radius: 4px;
  min-height: 0;
  font-family: "JetBrainsMono Nerd Font";
  font-size: 14px;
}

window#waybar {
  background: #2E3440; /* nord0 */
  transition-property: background-color;
  transition-duration: 0.5s;
  color: #D8DEE9; /* nord4 */
  border: 3px solid #88C0D0; /* nord8 */
  border-left: 3px solid #8FBCBB; /* nord7 */
  border-right: 3px solid #8FBCBB; /* nord7 */
  border-radius: 2px;
  opacity: 0.95;
}


/* === Workspaces ========================================================== */

#workspaces {
  background-color: transparent;
  padding-left: 40px;
}

#workspaces button {
  all: initial;
  min-width: 0;
  box-shadow: inherit;
  padding: 6px 6px;
  margin: 6px 3px;
  border-radius: 4px;
  background-color: #3B4252; /* nord1 */
  color: #D8DEE9; /* nord4 */
}

#workspaces button.active {
  color: #2E3440; /* nord0 */
  background-color: #88C0D0; /* nord8 */
}

#workspaces button:hover {
  color: #2E3440; /* nord0 */
  background-color: #8FBCBB; /* nord7 */
}


/* === Default Module Container Styling ==================================== */

.modules-right > widget > label,
.modules-right > widget > box {
  padding: 6px 12px;
  margin: 6px 6px;
  background-color: #3B4252; /* nord1 */
  border: 2px solid #88C0D0; /* nord8 */
  border-radius: 2px;
}
#tray {
  padding: 6px 12px;
  margin: 6px 6px;
  background-color: #3B4252; /* nord1 */
  border: 2px solid #88C0D0; /* nord8 */
  border-radius: 2px;
}

/* === Audio ============================================================== */

#pulseaudio.muted {
  background-color: #BF616A; /* nord11 red */
  color: #ECEFF4; /* nord6 */
}


/* === Bluetooth =========================================================== */

#bluetooth.disabled {
  color: #D08770; /* nord12 orange */
}

#custom-bluetooth {
  color: #8FBCBB; /* nord7 */
  transition: color 0.2s ease-in-out;
}


/* === Network ============================================================= */

#network.disconnected {
  background-color: #BF616A; /* nord11 red */
  color: #ECEFF4; /* nord6 */
}


/* === Clock =============================================================== */

#clock {
  font-weight: bold;
  font-size: 12px;
  color: #88C0D0; /* nord8 */
  padding: 6px 12px;
  margin: 6px 6px;
  background-color: #3B4252; /* nord1 */
  border: 2px solid #88C0D0; /* nord8 */
  border-radius: 2px;
}


/* === Asus Profile ======================================================== */

#custom-asus-profile {
  font-weight: bold;
  font-size: 12px;
  color: #EBCB8B; /* nord13 yellow */
}


/* === Battery ============================================================= */

#battery {
  border-radius: 2px;
  font-weight: normal;
}

/* 🔴 Critical */
#battery.critical {
  background-color: #BF616A; /* nord11 red */
  color: #ECEFF4; /* nord6 */
  padding: 2px 6px;
  animation-name: blink;
  animation-duration: 0.5s;
  animation-timing-function: linear;
  animation-iteration-count: infinite;
  animation-direction: alternate;
}

/* 🟠 Warning */
#battery.warning {
  background-color: #EBCB8B; /* nord13 yellow */
  color: #2E3440; /* nord0 */
  padding: 2px 6px;
}

/* === Tooltips ============================================================ */

tooltip {
  color: #D8DEE9; /* nord4 */
  background-color: #3B4252; /* nord1 */
  border: 1px solid #88C0D0; /* nord8 */
  font-weight: bold;
}

tooltip label {
  color: #88C0D0; /* nord8 */
}
    '';
    settings = [{
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
        format-icons = ["[ 󰤯 ]" "[ 󰤟 ]" "[ 󰤢 ]" "[ 󰤥 ]" "[ 󰤨 ]"];
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
          charging = ["󰢜" "󰂆" "󰂇" "󰂈" "󰢝" "󰂉" "󰢞" "󰂊" "󰂋" "󰂅"];
          default = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
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
          default = ["󰕿" "󰖀" "󰕾"];
        };
        on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        on-scroll-up = "wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+";
        on-scroll-down = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
        scroll-step = 5;
      };

      # ── Backlight ──
      backlight = {
        format = "󰛨  {percent}%";
        format-icons = ["󰃞" "󰃟" "󰃠" "󰃝" "󰃜" "󰃛"];
      };

      # ── Tray ──
      tray = {
        icon-size = 21;
        spacing = 10;
      };
    }];
  };
}
