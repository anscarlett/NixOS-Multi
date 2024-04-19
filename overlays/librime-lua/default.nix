{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "librime-lua";
  version = "2024-04-13";

  src = fetchFromGitHub {
    owner = "hchunhui";
    repo = "librime-lua";
    rev = "7c1b93965962b7c480d4d7f1a947e4712a9f0c5f";
    hash = "sha256-H/ufyHIfYjAjF/Dt3CilL4x9uAXGcF1BkdAgzIbSGA8=";
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
