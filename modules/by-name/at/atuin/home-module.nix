_:
{ lib, config, ... }:
{
  programs.atuin = {
    enable = true;
    settings.daemon.enabled = true;
  };

  home.activation.cleanAtuinDaemonSocket =
    let
      sock = "${config.home.homeDirectory}/.local/share/atuin/atuin.sock";
    in
    lib.hm.dag.entryAfter [ "writeBarrier" ] ''
      echo "Cleaning up Atuin daemon socket"
      $DRY_RUN_CMD rm ${sock}
    '';
}
