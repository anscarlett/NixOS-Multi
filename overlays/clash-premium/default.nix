{ fetchurl, stdenvNoCC, lib }:

stdenvNoCC.mkDerivation rec {
  pname = "clash-premium";
  version = "2023.05.29";

  src = fetchurl {
    url = "https://github.com/Dreamacro/clash/releases/download/premium/clash-linux-amd64-${version}.gz";
    hash = "sha256-pY0s0xuzoxdzWxHoOgztqf/MezIhvVBGBVYtJovHENU=";
  };

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/clash-premium.gz
    gzip --decompress $out/bin/clash-premium.gz
    chmod +x $out/bin/clash-premium
  '';

  meta = with lib; {
    homepage = "https://github.com/Dreamacro/clash";
    description = "Close-sourced pre-built Clash binary with TUN support and more";
    # license = licenses.unfree;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ yinfeng ];
  };
}
