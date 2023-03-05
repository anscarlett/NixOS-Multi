{ lib
, stdenv
, fetchurl
, autoPatchelfHook
, xorg
, gtk3
, pango
, at-spi2-atk
, nss
, libdrm
, alsa-lib
, mesa
, udev
, libappindicator
, imagemagick
, nodePackages
, makeDesktopItem
}:

let
  desktopItem = makeDesktopItem {
    name = "clash-for-windows";
    desktopName = "Clash for Windows";
    comment = "A Windows/macOS/Linux GUI based on Clash and Electron";
    icon = "clash-for-windows";
    exec = "cfw";
    categories = [ "Network" ];
  };
in
stdenv.mkDerivation rec {
  pname = "clash-for-windows";
  version = "0.20.16";

  src = fetchurl {
    url = "https://github.com/Fndroid/clash_for_windows_pkg/releases/download/0.20.16/Clash.for.Windows-0.20.16-x64-linux.tar.gz";
    hash = "sha256-pc55Pa2LwPGApdAcLqmnDZ9SKrT6hZ45ssBpFurT4Ps=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    imagemagick
    nodePackages.asar
  ];

  buildInputs = [
    gtk3
    pango
    at-spi2-atk
    nss
    libdrm
    alsa-lib
    mesa
  ] ++ (with xorg; [
    libXext
    libXcomposite
    libXrandr
    libxshmfence
    libXdamage
  ]);

  runtimeDependencies = [
    libappindicator
    udev
  ];

  installPhase = ''
    mkdir -p "$out/opt"
    cp -r . "$out/opt/clash-for-windows"

    mkdir -p "$out/bin"
    ln -s "$out/opt/clash-for-windows/cfw" "$out/bin/cfw"

    mkdir -p "$out/share/applications"
    install "${desktopItem}/share/applications/"* "$out/share/applications/"

    mkdir app-extract
    asar extract resources/app.asar app-extract
    raw_icon=app-extract/dist/electron/static/imgs/icon_512.png
    icon_dir="$out/share/icons/hicolor/512x512/apps"

    mkdir -p "$icon_dir"
    cp app-extract/dist/electron/static/imgs/icon_512.png "$icon_dir/clash-for-windows.png"
  '';

  meta = with lib; {
    description = "A Windows/macOS/Linux GUI based on Clash and Electron";
    homepage = "https://github.com/Fndroid/clash_for_windows_pkg";
    # license = licenses.unfree;
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "cfw";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ yinfeng ];
  };
}
