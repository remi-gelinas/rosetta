{ fetchzip, ... }:
{
  aerospace =
    let
      self = {
        pname = "aerospace";
        version = "0.13.1-Beta";

        src = fetchzip {
          url = "https://github.com/nikitabobko/AeroSpace/releases/download/v${self.version}/AeroSpace-v${self.version}.zip";
          hash = "sha256-0IpHc04B7DeJdd1XnYiBrdj8yAk0bylPnnvrTopLdvA=";
        };
      };
    in
    self;
}
