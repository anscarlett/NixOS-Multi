{ lib
, mkYarnPackage
, fetchYarnDeps
, fetchFromGitHub
, electron
, makeWrapper
}:

# WIP!!!
# cat pkgs/servers/web-apps/hedgedoc/default.nix
mkYarnPackage rec {
  pname = "koodo-reader";
  version = "1.5.7";

  src = fetchFromGitHub {
    owner = "troyeguo";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-PIE0BBcrWJRAazzzBmIKZcTfUBicWMigYL5uMF8dbFY=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    hash = "sha256-YV3WphP2pC1xeBuFmBiORyzHx8Qy4e6q45x8fTaW75o=";
  };

  nativeBuildInputs = [ makeWrapper ];

  distPhase = "true";

  configurePhase = ''
    cp -r "$node_modules" node_modules
    chmod -R u+w node_modules
  '';

  buildPhase = ''
    runHook preBuild

    # export HOME=$(mktemp -d)
    export NODE_OPTIONS=--openssl-legacy-provider
    yarn --offline build

    # patchShebangs node_modules
    # export PATH=$PWD/node_modules/.bin:$PATH

    runHook postbuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/share/{applications,koodo-reader}
    cp -r build/* $out/share/koodo-reader
    # cp -r ./* $out/share/koodo-reader

    # ln -s $out/share/koodo-reader/index.html $out/bin/${pname}

    # makeWrapper ${electron}/bin/electron $out/bin/${pname} \
    #   --argv0 "koodo-reader" \
    #   --add-flags "$out/share/koodo-reader"

    runHook postInstall
  '';

  meta = with lib; {
    description = "All-in-one ebook reader";
    homepage = "https://koodo.960960.xyz/";
    license = licenses.agpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
