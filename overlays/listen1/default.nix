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
, makeWrapper
}:
# WIP!!!
buildNpmPackage rec {
  pname = "listen1";
  version = "2.31.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = "listen1_desktop";
    rev = "v${version}";
    hash = "sha256-jYJsym4wKwykyylkLcVw5K+SYnoEpb0U4DG3kH1sUqo=";
    # fetchSubmodules = true;
  };

  npmDepsHash = "sha256-57KV6tZ8Vgpq/DDcuiPBhNMhfQVH1AstXjj1hZUiwFY=";

  makeCacheWritable = true;

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  npmPackFlags = [ "--ignore-scripts" ];

  NODE_OPTIONS = "--openssl-legacy-provider";

  # nativeBuildInputs = [ pkg-config python3 ];

  # buildInputs = [ libsecret electron nodejs];

  # makeCacheWritable = true;
  # npmFlags = [
  #   "--legacy-peer-deps"
  #   # "--ignore-scripts"
  # ];

  # NODE_OPTIONS = "--openssl-legacy-provider";

  # ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  # npmBuildScript = "build:production";

  # dontNpmBuild = true;

  # installPhase = ''
  #     mkdir -p $out
  #     cp -r node_modules $out/
  #   '';


  meta = with lib; {
    description = "One for all free music in china";
    homepage = "https://github.com/listen1/listen1_desktop";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
