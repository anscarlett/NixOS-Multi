{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (
  finalAttrs: {
    pname = "rime-ice";
    version = "2023-10-22";

    src = fetchFromGitHub {
      owner = "iDvel";
      repo = "rime-ice";
      rev = "ef1eb01d42eddeb4c3aa00af2a44a133070ab453";
      hash = "sha256-VH8PW9K/uMN6Hn9kklInh0RJmHxATjXbK6AHGGW+WBE=";
    };

    installPhase = ''
      mkdir -p $out/share/rime-data

      install -Dm644 *.{schema,dict}.yaml   $out/share/rime-data
      install -Dm644 *.{lua,gram}           $out/share/rime-data
      install -Dm644 symbols*.yaml          $out/share/rime-data
      install -Dm644 default.yaml           $out/share/rime-data

      mv lua       $out/share/rime-data
      mv opencc    $out/share/rime-data
      mv cn_dicts  $out/share/rime-data
      mv en_dicts  $out/share/rime-data
    '';

    meta = {
      description = "雾凇拼音，功能齐全，词库体验良好，长期更新修订";
      homepage = "https://github.com/iDvel/rime-ice";
      license = lib.licenses.gpl3Plus;
      platforms = lib.platforms.all;
      maintainers = with lib.maintainers; [ zendo ];
    };
  }
)
