{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, fetchYarnDeps
, wrapGAppsHook
, cargo
, rustc
, yarn
, nodejs
, fixup_yarn_lock
, pkg-config
, libayatana-appindicator
, gtk3
, webkitgtk
, libsoup
, openssl
, xdotool
, clash-geoip
, v2ray-geoip
, v2ray-domain-list-community
, clash
, clash-meta
}:

stdenv.mkDerivation rec {
  pname = "clash-verge";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "zzzgydi";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-8haJKUIYbVa/p3CtmwWVtbGZ2uan9VvaMgDpaEDH6tE=";
    postFetch = "sed -i -e 's/npmmirror/yarnpkg/g' $out/yarn.lock";
  };

  postPatch = ''
    sed -i -e '/externalBin/d' -e '/resources/d' src-tauri/tauri.conf.json

    pushd $cargoDepsCopy/libappindicator-sys
    oldHash=$(sha256sum src/lib.rs | cut -d " " -f 1)
    substituteInPlace $cargoDepsCopy/libappindicator-sys/src/lib.rs \
      --replace "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"
    newHash=$(sha256sum src/lib.rs | cut -d " " -f 1)
    substituteInPlace .cargo-checksum.json --replace "$oldHash" "$newHash"
    popd
  '';

  yarnDeps = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    hash = "sha256-UQJPa7MRweRH2g72+EGTBv94mive1c4Vq3L2IyHDsJs=";
  };

  cargoRoot = "src-tauri";
  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    sourceRoot = "source/src-tauri";
    name = "${pname}-${version}";
    hash = "sha256-VOpuwPWCWtPXZIIUxO3IR3Bb2bIGogZGlK21jMdxMto=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    cargo
    rustc
    yarn
    nodejs
    fixup_yarn_lock
    wrapGAppsHook
    pkg-config
  ];

  buildInputs = [
    gtk3
    libsoup
    libayatana-appindicator
    openssl
    webkitgtk
    xdotool
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
    # ln -s ${clash-geoip}/etc/clash/Country.mmdb $out/lib/clash-verge/resources/
    # ln -s ${v2ray-geoip}/share/v2ray/geoip.dat $out/lib/clash-verge/resources/
    # ln -s ${v2ray-domain-list-community}/share/v2ray/geosite.dat $out/lib/clash-verge/resources/
  '';

  postFixup = ''
    ln -s ${lib.getExe clash} $out/bin/clash
    ln -s ${lib.getExe clash-meta} $out/bin/clash-meta
  '';

  meta = with lib; {
    description = "A Clash GUI based on tauri";
    homepage = "https://github.com/zzzgydi/clash-verge";
    platforms = [ "x86_64-linux" ];
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ zendo ];
  };
}
