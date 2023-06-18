{ lib, fetchurl, appimageTools }:

let
  pname = "gitfiend";
  version = "0.42.0";

  src = fetchurl {
    url = "https://gitfiend.com/resources/GitFiend-${version}.AppImage";
    hash = "sha256-gZrzRvcmHobQTTsaSZo3ve60nKzlkWCesQDvP/DZ57g=";
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    mv $out/bin/${pname}-${version} $out/bin/${pname}

    mkdir -p $out/share/${pname}
    cp -a ${appimageContents}/{locales,resources} $out/share/${pname}
    cp -a ${appimageContents}/usr/share/icons $out/share/
    install -Dm 444 ${appimageContents}/${pname}.desktop -t $out/share/applications

    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = with lib; {
    description = "A Git client designed for humans";
    homepage = "https://gitfiend.com";
    license = licenses.mit;
    # license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ zendo ];
  };
}
