{
  imports = [ ./programs/yubikey-agent.nix ];

  programs.yubikey-agent = {
    enable = true;
    enableFishIntegration = true;
  };
}
