{
  stdenvNoCC,
  fetchFromGitHub,
  ...
}:
stdenvNoCC.mkDerivation rec {
  pname = "et-book";
  version = "24d3a3bbfc880095d3df2b9e9d60d05819138e89";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "edwardtufte";
    repo = "et-book";
    rev = version;
    hash = "sha256-9maMYSjVNrAo+0++28bXwn9719jFI1nYh02iu1yYF64=";
  };

  installPhase = ''
    runHook preInstall
    fontdir="$out/share/fonts/truetype"
    install -d "$fontdir"
    install $src/et-book/**/*.ttf "$fontdir"
    runHook postInstall
  '';
}
