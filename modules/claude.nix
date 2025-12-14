{ config, pkgs, ... }:

let
  defaultSettings = {
    includeCoAuthoredBy = false;
    permissions = {
      allow = [
        "WebSearch"
        "WebFetch"
        "mcp__context7__resolve-library-id"
        "mcp__context7__get-library-docs"
      ];
    };
  };
in
{
  # Provision Claude Code settings
  home.file.".claude/settings.json".text = builtins.toJSON defaultSettings;
}
