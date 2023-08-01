{ lib, fetchurl, appimageTools }:

let
  pname = "gitfiend";
  version = "0.42.1";

  src = fetchurl {
    url = "https://gitfiend.com/resources/GitFiend-${version}.AppImage";
    hash = "sha256-xYNEogwNH/ozoahZXks3r1hh8M55o+R707pxASxYvmE=";
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

  meta = {
    description = "A Git client designed for humans";
    homepage = "https://gitfiend.com";
    license = lib.licenses.mit;
    # license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ zendo ];
  };
}
