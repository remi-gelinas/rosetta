{
  config,
  hyprland,
  nixpkgs-unstable,
}: {
  varrock = import ./varrock {inherit config hyprland nixpkgs-unstable;} "x86_64-linux";
}
