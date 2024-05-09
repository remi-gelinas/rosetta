{
  config,
  nixpkgs-unstable,
  nixpkgs-firefox-darwin,
}:
{
  darwin = import ./darwin { inherit config nixpkgs-unstable nixpkgs-firefox-darwin; };
}
