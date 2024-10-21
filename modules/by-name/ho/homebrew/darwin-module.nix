{ pkgs, ... }:
{
  homebrew = {
    enable = true;

    onActivation = {
      cleanup = "zap";
      upgrade = true;
      autoUpdate = true;
    };

    global = {
      brewfile = true;
      autoUpdate = true;
    };

    casks = [
      "1password"
      "visual-studio-code"
      "discord"
      "orbstack"
      "vmware-fusion"
      "floorp"
    ];

    masApps = {
      XCode = 497799835;
    };
  };

  nix-homebrew = {
    enable = true;

    enableRosetta = pkgs.stdenv.hostPlatform.isAarch64;
  };
}
