{ config, pkgs, ... }:

{
  services.swaync = {
    enable = true;
    settings = {
      positionX = "right";
      positionY = "top";
      control-center-margin-top = 10;
      control-center-margin-right = 10;
      control-center-margin-bottom = 10;
      notification-icon-size = 64;
      notification-body-image-height = 100;
      notification-body-image-width = 200;
      timeout = 10;
      timeout-low = 5;
      timeout-critical = 0;
      fit-to-screen = true;
      keyboard-shortcuts = true;
      image-visibility = "when-available";
      transition-time = 200;
      hide-on-clear = false;
      hide-on-action = true;
      script-fail-notify = true;
    };

    # Nord-themed styling
    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font";
        font-size: 12px;
      }

      .notification-row {
        outline: none;
      }

      .notification {
        border-radius: 8px;
        margin: 6px 12px;
        box-shadow: 0 0 0 1px rgba(136, 192, 208, 0.3);
        padding: 0;
        background: rgba(46, 52, 64, 0.95);
      }

      .notification-content {
        background: transparent;
        padding: 6px;
        border-radius: 8px;
      }

      .summary {
        color: #ECEFF4;
        font-weight: bold;
      }

      .body {
        color: #D8DEE9;
      }

      .control-center {
        background: rgba(46, 52, 64, 0.95);
        border: 1px solid rgba(136, 192, 208, 0.3);
        border-radius: 12px;
      }

      .control-center-list {
        background: transparent;
      }

      .widget-title {
        color: #88C0D0;
        margin: 8px;
        font-size: 1.5rem;
      }

      .widget-dnd {
        margin: 8px;
        font-size: 1.1rem;
      }

      .widget-dnd > switch {
        background: #4C566A;
        border-radius: 8px;
      }

      .widget-dnd > switch:checked {
        background: #88C0D0;
      }
    '';
  };
}
