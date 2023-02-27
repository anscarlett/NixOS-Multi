{ lib
, stdenvNoCC
, fetchFromGitHub
}:

stdenvNoCC.mkDerivation rec {
  pname = "rime-ice";
  version = "2023-02-21";

  src = fetchFromGitHub {
    owner = "iDvel";
    repo = pname;
    rev = "196a0ea7a64f4f5321a516175245a390411a1bae";
    hash = "sha256-BzxdjWODRHEiYa/BYU6AczA9ATAAfNzi03HCjOKVm6c=";
  };

  installPhase = ''
    mkdir -p $out/share/rime-data

    install -Dm644 *.{schema,dict}.yaml   $out/share/rime-data
    install -Dm644 symbols_custom.yaml    $out/share/rime-data
    # install -Dm644 *.{lua,gram}           $out/share/rime-data

    mv opencc    $out/share/rime-data
    mv cn_dicts  $out/share/rime-data
    mv en_dicts  $out/share/rime-data
  '';

  meta = with lib; {
    description = "雾凇拼音，功能齐全，词库体验良好，长期更新修订";
    homepage = "https://github.com/iDvel/rime-ice";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ zendo ];
  };
}