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
    rev = "7d348f6a48ff1c9c0d232b5b58f8c36544c9705c";
    hash = "sha256-15qD3ktz1pf8jSeJDeyZ1J8a/RQMyVWHTF56nW0F46c=";
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
