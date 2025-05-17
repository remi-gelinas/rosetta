{ fetchFromGitHub, ... }:
{
  gh-poi =
    let
      self = {
        pname = "gh-poi";
        version = "v0.10.1";

        src = fetchFromGitHub {
          owner = "seachicken";
          repo = "gh-poi";
          rev = "v${self.version}";
          hash = "sha256-ZQkXXaa4n88bJdgP2FSXtgBrUi39teO98SzZq+I5doM=";
        };

        vendorHash = "sha256-D/YZLwwGJWCekq9mpfCECzJyJ/xSlg7fC6leJh+e8i0=";
      };
    in
    self;
}
