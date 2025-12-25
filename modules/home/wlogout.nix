{ config, pkgs, ... }:

{
  programs.wlogout = {
    enable = true;
    layout = [
      {
        label = "lock";
        action = "hyprlock";
        text = "Lock";
        keybind = "l";
      }
      {
        label = "logout";
        action = "hyprctl dispatch exit";
        text = "Logout";
        keybind = "e";
      }
      {
        label = "suspend";
        action = "systemctl suspend";
        text = "Suspend";
        keybind = "u";
      }
      {
        label = "reboot";
        action = "systemctl reboot";
        text = "Reboot";
        keybind = "r";
      }
      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "Shutdown";
        keybind = "s";
      }
    ];

    # Nord-themed styling
    style = ''
      * {
        background-image: none;
        font-family: "JetBrainsMono Nerd Font";
      }

      window {
        background-color: rgba(46, 52, 64, 0.9);
      }

      button {
        color: #ECEFF4;
        background-color: #3B4252;
        border-style: solid;
        border-width: 2px;
        border-color: #4C566A;
        background-repeat: no-repeat;
        background-position: center;
        background-size: 25%;
        border-radius: 12px;
        box-shadow: none;
        text-shadow: none;
        animation: gradient_f 20s ease-in infinite;
        margin: 10px;
      }

      button:focus {
        background-color: #434C5E;
        border-color: #88C0D0;
      }

      button:hover {
        background-color: #434C5E;
        border-color: #88C0D0;
        animation: gradient_f 20s ease-in infinite;
        transition: all 0.3s cubic-bezier(.55,0.0,.28,1.682);
      }

      #lock {
        background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/lock.png"));
      }

      #logout {
        background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/logout.png"));
      }

      #suspend {
        background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/suspend.png"));
      }

      #reboot {
        background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/reboot.png"));
      }

      #shutdown {
        background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/shutdown.png"));
      }
    '';
  };
}
