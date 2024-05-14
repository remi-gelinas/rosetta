{
  config,
  lib,
  nixpkgs-firefox-darwin,
}:
{
  darwin = import ./darwin { inherit config lib nixpkgs-firefox-darwin; };
}
