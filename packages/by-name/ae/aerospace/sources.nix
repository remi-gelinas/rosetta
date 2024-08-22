{ fetchzip, ... }:
{
  aerospace =
    let
      self = {
        pname = "aerospace";
        version = "0.14.1-Beta";

        src = fetchzip {
          url = "https://github.com/nikitabobko/AeroSpace/releases/download/v${self.version}/AeroSpace-v${self.version}.zip";
          hash = "sha256-uZKFMacXyU9p9pOF+onmX4boxFybfKed1EwyLCb08Dg=";
        };
      };
    in
    self;
}
