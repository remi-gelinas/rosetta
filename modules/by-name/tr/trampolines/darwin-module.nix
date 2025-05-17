{ pkgs, config, ... }:
{
  # FIXME: https://github.com/LnL7/nix-darwin/issues/214
  system.activationScripts.postUserActivation.text = ''
    echo "aliasing Nix Applications..."

    app_folder="/Applications/Nix Trampolines"
    rm -rf "$app_folder"
    mkdir -p "$app_folder"
    find "${config.system.build.applications}/Applications" -type l -print | while read -r app; do
        app_target="$app_folder/$(basename "$app")"
        real_app="$(readlink "$app")"
        echo "Aliasing \"$real_app\" to \"$app_target\"" >&2
        ${pkgs.mkalias}/bin/mkalias "$real_app" "$app_target"
    done
  '';
}
