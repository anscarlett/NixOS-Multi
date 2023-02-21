{ lib
, stdenv
, fetchurl
, dpkg
, wrapGAppsHook
, autoPatchelfHook
, udev
, alsa-lib
, cups
, libdrm
, libxshmfence
, mesa # for libgbm
, nss
, nspr
}:

stdenv.mkDerivation rec {
  pname = "csbooks";
  version = "7.5.0";

  src = fetchurl {
    url = "https://github.com/caesiumstudio/csBooks-updates/releases/download/latest/csBooks_${version}_amd64.deb";
    hash = "sha256-JOfEpldoirTQFwLcmZNYzrx2fJZFXpo6iI66ZLuMPH0=";
  };

  unpackPhase = "dpkg-deb -x $src .";

  nativeBuildInputs = [
    dpkg
    wrapGAppsHook
    autoPatchelfHook
  ];

  buildInputs = [
    alsa-lib
    cups
    libdrm
    libxshmfence
    mesa # for libgbm
    nss
    nspr
    stdenv.cc.cc
  ];

  runtimeDependencies = [
    (lib.getLib udev)
  ];

  installPhase = ''
    mkdir -p $out/bin
    mv usr/share $out
    mv opt $out
    ln -s $out/opt/csBooks/${pname} $out/bin/${pname}

    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace "Exec=/opt/csBooks/csbooks %U" "Exec=csbooks %U"
  '';

  meta = with lib; {
    description = "A Smart Book Manager and Reader";
    homepage = "https://caesiumstudio.com/csbooks/";
    platforms = [ "x86_64-linux" ];
    license = licenses.mit;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ zendo ];
  };
}
