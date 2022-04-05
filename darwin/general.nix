{ config, lib, pkgs, ... }:

{
  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  fonts = {
    enableFontDir = true;
    fonts = with pkgs; [
      pragmata-pro
    ];
  };
}
