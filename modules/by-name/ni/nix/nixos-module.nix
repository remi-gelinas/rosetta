{
  imports = [ ./common-module.nix ];

  nix = {
    settings.auto-optimise-store = true;
    channel.enable = false;
    gc.dates = "weekly";
  };
}
