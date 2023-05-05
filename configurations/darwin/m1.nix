{lib, ...}: {
  config.remi-nix.darwinConfigurations.M1 = {
    system = "aarch64-darwin";
  };

  config.remi-nix.darwinConfigurations.M1-ci = {
    system = "x86_64-darwin";

    primaryUser = {
      username = "runner";
      fullName = "";
      email = "";
      nixConfigDirectory = "/Users/runner/work/nixpkgs/nixpkgs";
    };

    modules = [{homebrew.enable = lib.mkForce false;}];
  };
}
