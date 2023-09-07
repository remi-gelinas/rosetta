# .nixd.nix
{
  eval = {
    target = {
      args = ["-f" "default.nix"];
      installable = "debug";
    };
    depth = 10;
  };
  formatting.command = "alejandra";
  options = {
    enable = true;
    target = {
      args = ["-f" "default.nix"];
      installable = "debug.options";
    };
  };
}
