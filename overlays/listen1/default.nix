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
    fetchSubmodules = true;
    hash = "sha256-Ch74V+GLNOeaYaJn3I1Ttv48DBc2abSjS6dfbxw9qRQ=";
  };

  npmDepsHash = "sha256-cDBYz0m3EVVYABLU5wb0NJkcZDC+YqMHBdiCSPdWLBo=";

  # nativeBuildInputs = [ pkg-config python3 ];

  # buildInputs = [ libsecret electron nodejs];

  makeCacheWritable = true;
  npmFlags = [
    "--legacy-peer-deps"
    # "--ignore-scripts"
  ];

  # NODE_OPTIONS = "--openssl-legacy-provider";

  ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  # npmBuildScript = "build:production";

  # dontNpmBuild = true;

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
