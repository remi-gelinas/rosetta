{
  nixpkgs-firefox-darwin,
  config,
  lib,
}:
system: {
  inherit system;

  primaryUser = config.primaryUser // rec {
    username = "runner";
    fullName = "";
    email = "";
    nixConfigDirectory = "/Users/${username}/work/nixpkgs/nixpkgs";
  };

  homeModules = [
    { inherit (config) nixpkgsConfig colors; }
  ] ++ builtins.attrValues config.homeManagerModules;

  modules = [
    {
      inherit (config) nixpkgsConfig colors;
      nixpkgs.overlays = [ nixpkgs-firefox-darwin.overlay ];
      homebrew.enable = lib.mkForce false;
    }
  ] ++ builtins.attrValues config.darwinModules;
}
