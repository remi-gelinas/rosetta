{
  pkgs,
  config,
  ...
}: {
  environment = {
    # Apps
    # `home-manager` currently has issues adding them to `~/Applications`
    # Issue: https://github.com/nix-community/home-manager/issues/1341
    systemPackages = with pkgs; [
      wezterm
      firefox-devedition-bin
    ];

    # https://github.com/nix-community/home-manager/issues/423
    variables = {
      TERMINFO_DIRS = [
        #"${pkgs.kitty.terminfo.outPath}/share/terminfo"
      ];
    };
  };

  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };
}
