{ config, pkgs, ... }:

{
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        source = "nixos";
        padding = {
          right = 1;
        };
      };
      display = {
        size = {
          binaryPrefix = "si";
        };
        color = {
          keys = "blue";
          output = "white";
        };
        separator = "  ";
      };
      modules = [
        "title"
        "separator"
        {
          type = "os";
          key = "OS";
        }
        {
          type = "host";
          key = "Host";
        }
        {
          type = "kernel";
          key = "Kernel";
        }
        {
          type = "uptime";
          key = "Uptime";
        }
        {
          type = "packages";
          key = "Packages";
        }
        {
          type = "shell";
          key = "Shell";
        }
        {
          type = "terminal";
          key = "Terminal";
        }
        {
          type = "terminalfont";
          key = "Font";
        }
        "separator"
        {
          type = "cpu";
          key = "CPU";
        }
        {
          type = "gpu";
          key = "GPU";
        }
        {
          type = "memory";
          key = "Memory";
        }
        {
          type = "disk";
          key = "Disk";
        }
        "separator"
        "colors"
      ];
    };
  };
}
