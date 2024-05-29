{
  lib,
  pkgs,
  config,
  ...
}:
{
  _file = ./trampolines.nix;

  home.activation = {
    # FIXME: https://github.com/nix-community/home-manager/issues/1341
    # https://github.com/nix-community/home-manager/issues/1341#issuecomment-2049723843
    aliasHomeManagerApplications = lib.mkIf pkgs.stdenv.isDarwin (
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        app_folder="${config.home.homeDirectory}/Applications/Home Manager Trampolines"
        rm -rf "$app_folder"
        mkdir -p "$app_folder"
        find "$genProfilePath/home-path/Applications" -type l -print | while read -r app; do
            app_target="$app_folder/$(basename "$app")"
            real_app="$(readlink "$app")"
            echo "Aliasing \"$real_app\" to \"$app_target\"" >&2
            $DRY_RUN_CMD ${pkgs.mkalias}/bin/mkalias "$real_app" "$app_target"
        done
      ''
    );
  };
}
