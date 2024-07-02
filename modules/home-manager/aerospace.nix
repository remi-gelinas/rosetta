{ lib, ... }:
{
  imports = [ ./programs/aerospace.nix ];

  programs.aerospace =
    let
      workspaces = {
        "Code" = {
          key = "c";
          apps = [ "com.microsoft.VSCode" ];
        };
        "Terminal" = {
          key = "t";
          apps = [ "dev.warp.Warp-Stable" ];
        };
        "Web" = {
          key = "w";
          apps = [ "org.mozilla.firefoxdeveloperedition" ];
        };
        "Social" = {
          key = "s";
          apps = [ "com.hnc.Discord" ];
        };
      };
    in
    {
      enable = true;

      config = {
        "start-at-login" = true;

        mode.main.binding =
          {
            # General movement

            # See: https://nikitabobko.github.io/AeroSpace/commands#layout
            alt-slash = "layout tiles horizontal vertical";
            alt-comma = "layout accordion horizontal vertical";

            # See: https://nikitabobko.github.io/AeroSpace/commands#focus;
            alt-h = "focus left";
            alt-j = "focus down";
            alt-k = "focus up";
            alt-l = "focus right";

            # See: https://nikitabobko.github.io/AeroSpace/commands#move;
            alt-shift-h = "move left";
            alt-shift-j = "move down";
            alt-shift-k = "move up";
            alt-shift-l = "move right";

            # See: https://nikitabobko.github.io/AeroSpace/commands#resize
            alt-shift-minus = "resize smart -50";
            alt-shift-equal = "resize smart +50";

            # Workspaces
            alt-s = "workspace Social";
            alt-w = "workspace Web";
            alt-t = "workspace Terminal";
            alt-c = "workspace Code";

            alt-shift-s = "move-node-to-workspace Social";
            alt-shift-w = "move-node-to-workspace Web";
            alt-shift-t = "move-node-to-workspace Terminal";
            alt-shift-c = "move-node-to-workspace Code";
          }
          # Generate shortcuts for each workspace
          // (lib.mapAttrs' (
            workspace: { key, ... }: lib.nameValuePair "alt-${key}" "workspace ${workspace}"
          ) workspaces)
          # Generate shortcuts to move nodes to each workspace
          // (lib.mapAttrs' (
            workspace: { key, ... }: lib.nameValuePair "alt-shift-${key}" "move-node-to-workspace ${workspace}"
          ) workspaces);

        "on-window-detected" =
          with lib;
          pipe workspaces [
            (mapAttrsToList (
              workspace:
              { apps, ... }:
              map (app: {
                "if".app-id = app;
                run = "move-node-to-workspace ${workspace}";
              }) apps
            ))
            flatten
          ];
      };
    };
}
