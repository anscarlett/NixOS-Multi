{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  wrapGAppsHook,
  autoPatchelfHook,
  openssl,
  webkitgtk,
  udev,
  libayatana-appindicator,
}:

stdenv.mkDerivation rec {
  pname = "clash-nyanpasu";
  version = "1.4.5";

  src = fetchurl {
    url = "https://github.com/LibNyanpasu/clash-nyanpasu/releases/download/v${version}/clash-nyanpasu_${version}_amd64.deb";
    hash = "sha256-cxaq7Rndf0ytEaqc7CGQix5SOAdsTOoTj1Jlhjr5wEA=";
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
  ];

  runtimeDependencies = [
    (lib.getLib udev)
    libayatana-appindicator
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mv usr/* $out

    runHook postInstall
  '';

  meta = with lib; {
    description = "Continuation of Clash Verge - A Clash Meta GUI based on Tauri";
    homepage = "https://github.com/LibNyanpasu/clash-nyanpasu";
    platforms = [ "x86_64-linux" ];
    license = licenses.gpl3Plus;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ zendo ];
    mainProgram = "clash-nyanpasu";
  };
}
