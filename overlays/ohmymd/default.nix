{ lib
, stdenv
, fetchurl
, dpkg
, wrapGAppsHook
, autoPatchelfHook
, openssl
, webkitgtk
, udev
, libayatana-appindicator
, nspr
, libdrm
, mesa
, alsa-lib
, systemd
, nss
, electron
, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "ohmymd";
  version = "0.5.0";

  src = fetchurl {
    url = "https://github.com/1oopstudio/support.ohmymd.app/releases/download/${version}/ohmymd_${version}_amd64.deb";
    hash = "sha256-gf4Eiaofq5kFIf9Hy1G8hvtLog7Jq8t23oHqlZxPrg8=";
  };

  unpackPhase = "dpkg-deb -x $src .";

  nativeBuildInputs = [
    dpkg
    # wrapGAppsHook
    makeWrapper
    autoPatchelfHook
  ];

  buildInputs = [
    stdenv.cc.cc
  ];

  # runtimeDependencies = [
  #   (lib.getLib udev)
  #   # libayatana-appindicator
  # ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share,ohmymd}
    cp opt/Oh\ Mymd/resources/app.asar $out/ohmymd
    cp -r usr/* $out

    makeWrapper ${electron}/bin/electron $out/bin/${pname} \
      --add-flags $out/ohmymd/app.asar

    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace "/opt/Oh Mymd/ohmymd" "ohmymd"

    runHook postInstall
  '';

  meta = with lib; {
    description = "A markdown editor support cloud sync";
    homepage = "https://www.ohmymd.app";
    platforms = [ "x86_64-linux" ];
    license = licenses.mit;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ zendo ];
  };
}
