{
  config,
  hyprland,
}: {
  varrock = import ./varrock {inherit config hyprland;} "x86_64-linux";
}
