{ lib
, stdenv
, fetchurl
, dpkg
, autoPatchelfHook
, wrapGAppsHook
, openssl
, webkitgtk
, udev
, libayatana-appindicator
}:
# WIP!!!
stdenv.mkDerivation rec {
  pname = "music-you";
  version = "2.1.0";

  src = fetchurl {
    url = "https://github.com/GuMengYu/music-you/releases/download/tauri-alpha-2/music-you-tauri_${version}_amd64.deb";
    hash = "sha256-7iBE4+A2og2P9hurfcVvLUrHRNFtl1TgJhaUQE2uX60=";
  };

  unpackPhase = "dpkg-deb -x $src .";

  nativeBuildInputs = [
    dpkg
    wrapGAppsHook
    # makeWrapper
    autoPatchelfHook
  ];

  buildInputs = [
    openssl
    webkitgtk
    stdenv.cc.cc
  ];

  runtimeDependencies = [
    (lib.getLib udev)
    libayatana-appindicator
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp usr/bin/music-you-tauri $out/bin
    cp -r usr/share $out

    runHook postInstall
  '';

  meta = with lib; {
    description = "一个美观简约的Material Design 3 (Material You) 风格网易云音乐播放器pc客户端";
    homepage = "https://github.com/GuMengYu/music-you";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
