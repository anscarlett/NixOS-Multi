{ lib
, stdenv
, fetchurl
, dpkg
, wrapGAppsHook
, autoPatchelfHook
, clash-meta
, openssl
, webkitgtk
, udev
, libayatana-appindicator
}:

stdenv.mkDerivation rec {
  pname = "clash-nyanpasu";
  version = "1.4.1";

  src = fetchurl {
    url = "https://github.com/keiko233/clash-nyanpasu/releases/download/v${version}/clash-nyanpasu_${version}_amd64.deb";
    hash = "sha256-GX95zR71q7i6LrHAj/rMXfuFG1wKZFGXHZlD/O3SoII=";
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
    # rm $out/bin/{clash,clash-meta}

    runHook postInstall
  '';

  # postFixup = ''
  #   ln -s ${lib.getExe clash-meta} $out/bin/clash-meta
  # '';

  meta = with lib; {
    description = "A Clash GUI based on tauri";
    homepage = "https://github.com/keiko233/clash-nyanpasu";
    platforms = [ "x86_64-linux" ];
    license = licenses.gpl3Plus;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ zendo ];
    mainProgram = "clash-nyanpasu";
  };
}
