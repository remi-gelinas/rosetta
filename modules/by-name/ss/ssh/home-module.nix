{ pkgs, config, ... }:
let
  inherit (pkgs.stdenv) isDarwin;

  # Socket paths from https://nixos.wiki/wiki/1Password
  onePassSocketPath =
    if isDarwin then
      "${config.home.homeDirectory}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
    else
      "${config.home.homeDirectory}/.1password/agent.sock";
in
{
  programs = {
    fish.interactiveShellInit = ''
      set -x SSH_AUTH_SOCK "${onePassSocketPath}"
    '';

    ssh.enable = false;
  };

}
