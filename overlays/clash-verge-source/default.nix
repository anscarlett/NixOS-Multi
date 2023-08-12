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
# https://github.com/archlinuxcn/repo/blob/master/archlinuxcn/clash-verge/PKGBUILD
stdenv.mkDerivation rec {
  pname = "clash-verge";
  version = "1.3.6";

  src = fetchFromGitHub {
    owner = "zzzgydi";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-8EFgkxs8DFkLjD2gBFWFoOrdEAEKRvkCZ3gFm52pOJU=";
    # postFetch = "sed -i -e 's/npmmirror/yarnpkg/g' $out/yarn.lock";
  };

  postPatch = ''
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

    mkdir src-tauri/{sidecar,resources}
    ln -s ${lib.getExe clash} src-tauri/sidecar/clash-x86_64-unknown-linux-gnu
    ln -s ${lib.getExe clash-meta} src-tauri/sidecar/clash-meta-x86_64-unknown-linux-gnu

    ln -s ${clash-geoip}/etc/clash/Country.mmdb src-tauri/resources/
    ln -s ${v2ray-geoip}/share/v2ray/geoip.dat src-tauri/resources/
    ln -s ${v2ray-domain-list-community}/share/v2ray/geosite.dat src-tauri/resources/
  '';

  yarnDeps = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    hash = "sha256-pPw37TpkHjMMgSuEUOlFeb3nDZXOgJdhcyrWJ+dxAkE=";
  };

  cargoRoot = "src-tauri";
  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    sourceRoot = "source/src-tauri";
    name = "${pname}-${version}";
    hash = "sha256-d58TlaHJMswAe/CJJXQpOYAHJADkQmk9j1hEBKZ1R80=";
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
    # gtk3
    # libsoup
    # xdotool
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

  postInstall = ''
    mv src-tauri/target/release/bundle/deb/*/data/usr/ $out
  '';

  meta = {
    description = "A Clash GUI based on tauri";
    homepage = "https://github.com/zzzgydi/clash-verge";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "clash-verge";
  };
}
