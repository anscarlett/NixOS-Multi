{ lib
, buildNpmPackage
, fetchFromGitHub
, electron
, openssl
, libsecret
, esbuild
, pkg-config
, python3
  , nodejs
}:
# WIP!!!
buildNpmPackage rec {
  pname = "listen1";
  version = "2.28.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = "listen1_desktop";
    rev = "v${version}";
    hash = "sha256-xPEOOtWrCdpOE1piZX8ncNTxW6FnPc7yEzk/RbpytJc=";
  };

  npmDepsHash = "sha256-/exiIPirhMZAag30jDrF196u+ZmI61oQc6ZjOVbJPR4=";

  # dontNpmBuild = true;

  # postPatch = ''
  #   substituteInPlace package.json --replace '"version": "0.0.0"' '"version": "${version}"'
  # '';

  # nativeBuildInputs = [ pkg-config python3 ];

  buildInputs = [ libsecret electron nodejs];

  makeCacheWritable = true;
  npmFlags = [
    "--legacy-peer-deps"
    "--ignore-scripts"
  ];

  npmBuild = ''
    npm run dist:linux64
  '';

  # The prepack script runs the build script, which we'd rather do in the build phase.
  # npmPackFlags = [ "--ignore-scripts" ];

  NODE_OPTIONS = "--openssl-legacy-provider";

  ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  # ESBUILD_BINARY_PATH = "${esbuild}/bin/esbuild";
  USE_SYSTEM_LIBDELTACHAT = "true";

  dontNpmBuild = true;

  # installPhase = ''
  #     mkdir -p $out
  #     cp -r node_modules $out/
  #   '';


  meta = with lib; {
    description = "A simple, clean and cross-platform music player";
    homepage = "https://github.com/listen1/listen1_desktop";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ zendo ];
  };
}
