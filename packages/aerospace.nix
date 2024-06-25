{
  stdenv,
  lib,
  fetchzip,
  installShellFiles,
}:
stdenv.mkDerivation rec {
  pname = "aerospace";
  version = "0.12.0-Beta";

  nativeBuildInputs = [ installShellFiles ];

  src = fetchzip {
    url = "https://github.com/nikitabobko/AeroSpace/releases/download/v${version}/AeroSpace-v${version}.zip";
    hash = "sha256-8po13LnL5x5mGIjPmtyH7yVm3htAJ2CyNpqSb1yLt0Q=";
  };

  phases = [
    "unpackPhase"
    "installPhase"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications $out/bin $out/man $out/completions
    cp -avi *.app $out/Applications/
    cp -avi bin/* $out/bin/
    cp -avi manpage/* $out/man/
    cp -avi shell-completion/bash/aerospace $out/completions/aerospace.bash
    cp -avi shell-completion/zsh/_aerospace $out/completions/aerospace.zsh
    cp -avi shell-completion/fish/aerospace.fish $out/completions/aerospace.fish

    runHook postInstall
  '';

  postInstall = ''
    installManPage $out/man/*
    installShellCompletion $out/completions/aerospace.{bash,fish,zsh}
  '';

  meta = with lib; {
    platforms = platforms.darwin;
  };
}
