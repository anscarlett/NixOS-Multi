{ lib, fetchurl, appimageTools }:

let
  pname = "fluent-reader";
  version = "1.1.3";

  src = fetchurl {
    url = "https://github.com/yang991178/${pname}/releases/download/v${version}/Fluent.Reader.${version}.AppImage";
    hash = "sha256-CzvhOaWfZ4rt2HmL/yv6P7IxEPLoyuBhftOxcjdMInU=";
  };

  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    mv $out/bin/${pname}-${version} $out/bin/${pname}

    mkdir $out/share
    cp -a ${appimageContents}/usr/share/icons $out/share/
    install -Dm 444 ${appimageContents}/${pname}.desktop -t $out/share/applications

    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = with lib; {
    description = "Modern desktop RSS reader built with Electron, React, and Fluent UI";
    homepage = "https://hyliu.me/fluent-reader/";
    license = licenses.bsd3;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ zendo ];
  };
}