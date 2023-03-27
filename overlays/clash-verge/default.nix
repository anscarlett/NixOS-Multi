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
  makeWrapper,
}:
stdenv.mkDerivation rec {
  pname = "clash-verge";
  version = "1.3.0";

  src = fetchurl {
    url = "https://github.com/zzzgydi/clash-verge/releases/download/v${version}/clash-verge_${version}_amd64.deb";
    hash = "sha256-HaBr1QHU3SZix3NFEkTmMrGuk/J1dfP3Lhst79rkUl0=";
  };

  unpackPhase = "dpkg-deb -x $src .";

  nativeBuildInputs = [
    dpkg
    # wrapGAppsHook
    makeWrapper
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

  # preBuild = ''
  #   addAutoPatchelfSearchPath ${src}/usr/lib/clash-verge/resources/
  # '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    # mv usr/* $out
    cp -r usr $out
    mv $out/usr/share $out
    ln -s $out/usr/bin/clash-verge $out/bin

    #wrapProgram $out/usr/bin/clash-verge "/usr/lib" \
     # --run "cd $out/usr/lib"
    # makeWrapper $out/usr/bin/clash-verge $out/bin/clash-verge \
      # --run "cd $out/usr/lib/clash-verge/resources"
      #--prefix LD_LIBRARY_PATH : "$out/usr/lib/clash-verge/resources"

    runHook postInstall
  '';

  #  preFixup = ''
  #    makeWrapperArgs+=(--prefix LD_LIBRARY_PATH : "$out/usr/lib"
  # "''${gappsWrapperArgs[@]}")
  #  '';

  meta = with lib; {
    description = "A Clash GUI based on tauri";
    homepage = "https://github.com/zzzgydi/clash-verge";
    platforms = ["x86_64-linux"];
    license = licenses.gpl3Plus;
    sourceProvenance = with sourceTypes; [binaryNativeCode];
    maintainers = with maintainers; [zendo];
  };
}
