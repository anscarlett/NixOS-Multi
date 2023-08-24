{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "librime-lua";
  version = "2023-06-25";

  src = fetchFromGitHub {
    owner = "hchunhui";
    repo = "librime-lua";
    rev = "c985eb399d63c491c6e03fa1651ddb59e485c04a";
    hash = "sha256-tpyX0NxAlNZ4Qeml2BeM0NbPN5xDW/uH/f0eqjBQKIM=";
  };

  installPhase = ''
    mkdir -p $out
    cp -r ./* $out
  '';

  meta = {
    description = "Extending RIME with Lua scripts";
    homepage = "https://github.com/hchunhui/librime-lua";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ zendo ];
  };
})
