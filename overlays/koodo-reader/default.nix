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
  version = "1.5.5";

  src = fetchFromGitHub {
    owner = "troyeguo";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-YPvs+uRHqxtq+nQYuJ0bLy9Kf6s0Df3PjzraxnVvAo8=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    hash = "sha256-FNAfsoZmzJG7jFs3zBdgNjp4hvmVi1l3DWG6H8y8ucA=";
  };

  # ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

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

    mkdir -p $out/share/{applications,koodo-reader}
    cp -r build/* $out/share/koodo-reader
    # cp -r ./* $out/share/koodo-reader

    makeWrapper ${electron}/bin/electron $out/bin/${pname} \
      --argv0 "koodo-reader" \
      --add-flags "$out/share/koodo-reader"

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
