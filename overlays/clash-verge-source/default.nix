{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, fetchYarnDeps
, cargo
, rustc
, yarn
, nodejs
, fixup_yarn_lock
, pkg-config
, wrapGAppsHook
, gtk3
, libsoup
, xdotool
, openssl
, webkitgtk
, libayatana-appindicator
, clash-geoip
, v2ray-geoip
, v2ray-domain-list-community
, clash
, clash-meta
}:

stdenv.mkDerivation rec {
  pname = "clash-verge";
  version = "1.3.5";

  src = fetchFromGitHub {
    owner = "zzzgydi";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-6gr+XPs8s2fe76Dclx1OZnDSmo+XeZQGRLNsRyFuYwc=";
    postFetch = "sed -i -e 's/npmmirror/yarnpkg/g' $out/yarn.lock";
  };

  postPatch = ''
    sed -i -e '/externalBin/d' -e '/resources/d' src-tauri/tauri.conf.json

    pushd $cargoDepsCopy/libappindicator-sys
    oldHash=$(sha256sum src/lib.rs | cut -d " " -f 1)
    substituteInPlace src/lib.rs \
      --replace "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"
    newHash=$(sha256sum src/lib.rs | cut -d " " -f 1)
    substituteInPlace .cargo-checksum.json --replace "$oldHash" "$newHash"
    popd

    pushd $cargoDepsCopy/tauri-utils
    oldHash=$(sha256sum src/platform.rs | cut -d " " -f 1)
    substituteInPlace src/platform.rs --replace "\"/usr" "\"$out"
    newHash=$(sha256sum src/platform.rs | cut -d " " -f 1)
    substituteInPlace .cargo-checksum.json --replace "$oldHash" "$newHash"
    popd
  '';

  yarnDeps = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    hash = "sha256-80qrq9yolq7r8d+j0SFyr/seVpXefpLpDeAeY2Agphk=";
  };

  cargoRoot = "src-tauri";
  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    sourceRoot = "source/src-tauri";
    name = "${pname}-${version}";
    hash = "sha256-yf0T1f0oHjNTFm36vwBGNCTRnjn+4z19r3xP5YtiA6Y=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    cargo
    rustc
    yarn
    nodejs
    fixup_yarn_lock
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    libsoup
    xdotool
    openssl
    webkitgtk
    libayatana-appindicator
  ];

  preBuild = ''
    export HOME=$(mktemp -d)
    chmod +w yarn.lock
    yarn config --offline set yarn-offline-mirror ${yarnDeps}
    fixup_yarn_lock yarn.lock
    yarn install --offline --frozen-lockfile --ignore-scripts --no-progress --non-interactive
    patchShebangs node_modules/
    yarn --offline build -b deb
  '';

  preInstall = ''
    mv src-tauri/target/release/bundle/deb/*/data/usr/ $out
    mkdir -p $out/lib/clash-verge/resources/
    ln -s ${clash-geoip}/etc/clash/Country.mmdb $out/lib/clash-verge/resources/
    ln -s ${v2ray-geoip}/share/v2ray/geoip.dat $out/lib/clash-verge/resources/
    ln -s ${v2ray-domain-list-community}/share/v2ray/geosite.dat $out/lib/clash-verge/resources/
  '';

  postFixup = ''
    ln -s ${lib.getExe clash} $out/bin/clash
    ln -s ${lib.getExe clash-meta} $out/bin/clash-meta
  '';

  meta = {
    description = "A Clash GUI based on tauri";
    homepage = "https://github.com/zzzgydi/clash-verge";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ zendo ];
  };
}
