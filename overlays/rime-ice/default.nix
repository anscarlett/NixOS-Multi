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
    rev = "23a8c8efb46c66ad3eb730255a36382481b99c00";
    hash = "sha256-yl6PgYW2vudftA8/NOnK5Va+bT3Z/7QCFoQCUOCGDuM=";
  };

  installPhase = ''
    mkdir -p $out/share/rime-data

    install -Dm644 *.{schema,dict}.yaml   $out/share/rime-data
    install -Dm644 symbols_custom.yaml    $out/share/rime-data
    # install -Dm644 *.{lua,gram}           $out/share/rime-data

    cp -r opencc    $out/share/rime-data
    cp -r cn_dicts  $out/share/rime-data
    cp -r en_dicts  $out/share/rime-data
  '';

  meta = with lib; {
    description = "雾凇拼音，功能齐全，词库体验良好，长期更新修订";
    homepage = "https://github.com/iDvel/rime-ice";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ zendo ];
  };
}
