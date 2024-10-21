{ config, ... }:
{
  flake.nixosConfigurations.vmware-fixture = config.flake.nixosConfigurations.fixture.extendModules {
    modules = [ ./modules/hardware.nix ];
  };
}
