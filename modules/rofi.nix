{ pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    font = "JetBrainsMono Nerd Font 12";

    # Basic setup from config.rasi
    extraConfig = {
      modi = "drun,run";
      show-icons = true;
    };

    # Theming (incorporating content from theme.rasi)
    theme = let
      # We will inline the theme content here since Home Manager handles themes
      inherit (pkgs) writeText;
      themeFile = writeText "rofi-theme.rasi" ''
        /* ── Rofi Theme ──────────────────────────────
           °˖* ૮(  • ᴗ ｡)っ🍸  pewdiepie/archdaemon/dionysh/shhheersh
           Vers 1.0
           Description: Custom styling for Rofi launcher 
           ─────────────────────────────────────────── */

        /* Global defaults */
        * {
          font: "JetBrainsMono Nerd Font 11";
          background-color: transparent;
          border-radius: 0px; 
          text-color: #fab387; /* Default text color derived from element text */
        }

        /* ── Window ──────────────────────────────── */
        window {
          width: 750px;
          height: 625px;
          location: center;
          border: 2px;
          border-radius: 3px;
          border-color: #61afef;
          background-color: transparent;
          padding: 0px;
          margin: 30px 50px;
        }

        /* ── Layout ──────────────────────────────── */
        mainbox {
          orientation: horizontal;
          children: [ imagebox, listview ]; /* Direct children since we can't easily emulate the complex nested box structure of remote without more work, simplifying for now */
          spacing: 0px;
          padding: 0px;
        }

        /* ── Imagebox (Simplified) ───────────────── */
        /* Note: NixOS builds are immutable/read-only. 
           We can't rely on ~/.config/rofi/image.png existing unless we put it there.
           For now we will disable the image box to prevent errors or empty gaps. 
        */
        imagebox {
            expand: false;
            size: 0px; 
        }

        /* ── Scrollbar ───────────────────────────── */
        scrollbar {
            width: 0px ;
            border: 0;
            handle-width: 0px ;
            padding: 0;
        }

        /* ── Elements ────────────────────────────── */
        element {
          padding: 6px 8px;
          spacing: 2px;
          text-color: #fab387;
          border-radius: 0px;
          orientation: horizontal;
          children: [ element-icon, element-text ];
        }

        element-icon {
            size: 24px;
            padding: 0px 5px 0px 0px; 
        }

        element selected {
          background-color: #191919;
          text-color: #e5c07b;
          border-radius: 3px;
        }
        
        element-text {
            vertical-align: 0.5;
        }

        /* ── Input & Prompt ──────────────────────── */
        inputbar {
          children: [ entry ];
          padding: 0px;
          margin: 0px;
        }
        
        prompt {
          enabled: false;
        }

        entry {
          padding: 12px;
          expand: false;
          font: "JetBrainsMono Nerd Font 12";
          text-color: #fab387;
          placeholder: "Search...";
          background-color: #292e36;
          border-radius: 3px 3px 0px 0px;
        }

        /* ── Listview ────────────────────────────── */
        listview {
          lines: 10;
          columns: 1;
          background-color: rgba(46, 52, 64, 0.95);
          border-radius: 0px 0px 3px 3px;
          padding: 10px;
        }
      '';
    in "${themeFile}";
  };
}
