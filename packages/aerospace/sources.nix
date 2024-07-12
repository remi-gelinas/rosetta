{ fetchzip, ... }:
{
  aerospace =
    let
      self = {
        pname = "aerospace";
        version = "0.12.0-Beta";

        src = fetchzip {
          url = "https://github.com/nikitabobko/AeroSpace/releases/download/v${self.version}/AeroSpace-v${self.version}.zip";
          hash = "sha256-8po13LnL5x5mGIjPmtyH7yVm3htAJ2CyNpqSb1yLt0Q=";
        };
      };
    in
    self;
}
