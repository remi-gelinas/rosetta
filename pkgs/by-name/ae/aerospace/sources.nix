{ fetchzip, ... }:
{
  aerospace =
    let
      self = {
        pname = "aerospace";
        version = "0.17.1-Beta";

        src = fetchzip {
          url = "https://github.com/nikitabobko/AeroSpace/releases/download/v${self.version}/AeroSpace-v${self.version}.zip";
          hash = "sha256-IMU0s57dpes7Vm2Wv191LwkRgiF+ZIqNWHzrl4a1Pm0=";
        };
      };
    in
    self;
}
