{ lib
, stdenvNoCC
, fetchFromGitHub
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "rime-ice";
  version = "2023-03-13";

  src = fetchFromGitHub {
    owner = "iDvel";
    repo = "rime-ice";
    rev = "9b05c4bf93a20ec37dce45a621c7ba545fa8a6e3";
    hash = "sha256-C/1HXCxHXAK0f4r8BFsWhiDQu9DtarpIjZ3VbJL5j0k=";
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
})
