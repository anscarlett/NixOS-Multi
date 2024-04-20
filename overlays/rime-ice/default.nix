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
    rev = "d3bbbef8f5696a3afc20ab6736d5e0cbe9b69051";
    hash = "sha256-Diz3iRorbkIkq9YC1jBUZxO9TCSNmEP97IU9tGXy0to=";
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
