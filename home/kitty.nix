{ config, lib, pkgs, ... }:
{
  programs = {
    kitty = {
      enable = true;

      font = {
        name = "PragmataPro Mono Liga";
        size = 18;
      };

      settings = {
        adjust_line_height = "140%";
        disable_ligatures = "cursor";

        hide_window_decorations = "titlebar-only";
        window_padding_width = "10";
      };

      extraConfig = with pkgs.lib.colors.nord.colors; ''
        font_features PragmataProMonoLiga-Italic +ss06
        font_features PragmataProMonoLiga-BoldItalic +ss07

        color0 #${nord1}
        color8 #${nord3}

        color1 #${nord11}
        color9 #${nord11}

        color2 #${nord14}
        color10 #${nord14}

        color3 #${nord13}
        color11 #${nord13}

        color4 #${nord9}
        color12 #${nord9}

        color5 #${nord15}
        color13 #${nord15}

        color6 #${nord8}
        color14 #${nord7}

        color7 #${nord5}
        color15 #${nord6}

        foreground #${nord4}
        background #${nord0}
        selection_foreground #000000
        selection_background #FFFACD
        url_color #0087BD
        cursor #${nord9}
      '';
    };
  };
}
