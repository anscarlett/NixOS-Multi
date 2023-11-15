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
, nss
, alsa-lib
}:
# WIP!!!
stdenv.mkDerivation rec {
  pname = "music-you";
  version = "3.0.0";

  src = fetchurl {
    url = "https://github.com/GuMengYu/music-you/releases/download/v3.0.0-alpha.2/music-you_3.0.0-alpha.2_amd64.deb";
    hash = "sha256-UhLfMENMI706LAkZBDbP2rNW9cTEZ8lkmhlLTpDFvrg=";
  };

  nativeBuildInputs = [
    dpkg
    wrapGAppsHook
    autoPatchelfHook
  ];

  buildInputs = [
    openssl
    webkitgtk
    stdenv.cc.cc
    nss
    alsa-lib
  ];

  runtimeDependencies = [
    (lib.getLib udev)
    # libayatana-appindicator
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r opt $out
    cp -r usr/share $out
    ln -s $out/opt/music-you/music-you $out/bin

    substituteInPlace $out/share/applications/music-you.desktop \
       --replace 'Exec=/opt/music-you/music-you %U' 'Exec=music-you %U'

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
