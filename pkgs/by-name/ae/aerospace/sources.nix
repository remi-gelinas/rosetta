{ fetchzip, ... }:
{
  aerospace =
    let
      self = {
        pname = "aerospace";
        version = "0.16.2-Beta";

        src = fetchzip {
          url = "https://github.com/nikitabobko/AeroSpace/releases/download/v${self.version}/AeroSpace-v${self.version}.zip";
          hash = "sha256-F208+EibyHlCImNig9lHuY05jGoXqNHsCRDKfqAR3g4=";
        };
      };
    in
    self;
}
