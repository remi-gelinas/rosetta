{ config, inputs, ... }:
{
  flake.nixosConfigurations.wsl-fixture = config.flake.nixosConfigurations.fixture.extendModules {
    modules = [
      inputs.nixos-wsl.nixosModules.default
      {
        wsl = {
          enable = true;
          defaultUser = "remi";
        };

        boot.loader.systemd-boot.enable = false;
      }
    ];
  };
}
