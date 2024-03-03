{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "librime-lua";
  version = "2024-02-06";

  src = fetchFromGitHub {
    owner = "hchunhui";
    repo = "librime-lua";
    rev = "7f3eca2ce659fc2401b8acb52bd2182b433e12b1";
    hash = "sha256-n+KCu8JmFBGPyfBgeLiFqND3wmQs/4eOZjqTXuaW+hk=";
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
