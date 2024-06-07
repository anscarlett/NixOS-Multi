{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "rime-ice";
  version = "2024-04-19";

  src = fetchFromGitHub {
    owner = "iDvel";
    repo = "rime-ice";
    rev = "af2480ba1b147a6a54c0c21e2997ef451c34e036";
    hash = "sha256-3KfuCHGFFcEzgprvJzJiyot8HqYWHvDhIu4Qo6Tu6Ys=";
  };

  installPhase = ''
    mkdir -p $out/share/rime-data
    cp -r ./* $out/share/rime-data
  '';

  meta = {
    description = "雾凇拼音，功能齐全，词库体验良好，长期更新修订";
    homepage = "https://github.com/iDvel/rime-ice";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ zendo ];
  };
})
