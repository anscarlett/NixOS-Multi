{ lib
, stdenv
, fetchFromGitHub
, mkYarnPackage
, fetchYarnDeps
, rustPlatform
, dbus
, freetype
, openssl
, pkg-config
, webkitgtk
, libcap
, libayatana-appindicator
, clash-premium
, clash-meta
, clash-geoip
, cargo-tauri
}:

# WIP!!!
# https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=clash-verge
let
  pname = "clash-verge";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "zzzgydi";
    repo = "clash-verge";
    rev = "v1.3.0";
    hash = "sha256-1dE7MSZfeYK7cD5B55byhRMU2p0RJWno4GJFMVsIEpQ=";
  };

  frontend-build = mkYarnPackage {
    inherit version src;
    pname = "clash-verge-ui";

    # offlineCache = fetchYarnDeps {
    #   yarnLock = src + "/yarn.lock";
    #   hash = "sha256-SesccsQa9f7KVlZcsss2sGIuTbz5+xy/sHdwaufEuek=";
    # };

    packageJSON = ./package.json;
    yarnLock = ./yarn.lock;
    yarnNix = ./yarn.nix;

    # buildPhase = ''
    #   runHook preBuild

    #   # export HOME=$(mktemp -d)
    #   # yarn run check
    #   # yarn --offline build
    #   # yarn tauri build
    #   # cp -r deps/clash-verge $out

    #   runHook postBuild
    # '';

    distPhase = "true";
    # dontInstall = true;

    preBuild = ''
       mkdir -p src-tauri/sidecar
       cp ${lib.getExe clash-premium} src-tauri/sidecar/clash-x86_64-unknown-linux-gnu
       cp ${lib.getExe clash-meta} src-tauri/sidecar/clash-meta-x86_64-unknown-linux-gnu
    '';
  };
in
rustPlatform.buildRustPackage rec {
  inherit version src pname;

  sourceRoot = "source/src-tauri";

  cargoHash = "sha256-loY+D27icpawHRM6bLRnsEBlEpdMAAw/W7SFOQED9AQ=";

  # Copy the frontend static resources to final build directory
  # Also modify tauri.conf.json so that it expects the resources at the new location
  postPatch = ''
    mkdir -p frontend-build
    cp -R ${frontend-build}/src frontend-build
    # substituteInPlace tauri.conf.json --replace '"distDir": "../out/src",' '"distDir": "frontend-build/src",'

    # mkdir -p src-tauri/sidecar
    # cp ${lib.getExe clash-premium} src-tauri/sidecar/clash-x86_64-unknown-linux-gnu
  '';

  nativeBuildInputs = [ pkg-config cargo-tauri ];

  buildInputs = [
    dbus
    openssl
    freetype
    webkitgtk
  ];

  buildPhase = ''
    cargo-tauri build
  '';

  # Skip one test that fails ( tries to mutate the parent directory )
  # checkFlags = [ "--skip=test_file_operation" ];


  meta = with lib; {
    description = "A Clash GUI based on tauri. Supports Windows, macOS and Linux";
    homepage = "https://github.com/zzzgydi/clash-verge";
    license = licenses.gpl3Plus;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ zendo ];
  };
}
