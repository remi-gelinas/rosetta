{ pkgs, ... }: {
  programs.fish = {
    enable = true;

    plugins = with pkgs; [
      {
        name = "bass";
        inherit (fishPlugins.bass) src;
      }
    ];

    interactiveShellInit = ''
      set -g fish_greeting ""
    '';
  };
}
