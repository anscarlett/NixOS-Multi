{ lib
, stdenvNoCC
, fetchFromGitHub
}:

stdenvNoCC.mkDerivation rec {
  pname = "rime-ice";
  version = "2023-03-13";

  src = fetchFromGitHub {
    owner = "iDvel";
    repo = pname;
    rev = "656ec1852124f6fcc621282ecb93c0e146347171";
    hash = "sha256-U3+brZrt4XkeUd5PX5PF19txkE4ZwvK20Qcdhx1CoW4=";
  };

  installPhase = ''
    mkdir -p $out/share/rime-data

    install -Dm644 *.{schema,dict}.yaml   $out/share/rime-data
    install -Dm644 symbols*.yaml          $out/share/rime-data
    install -Dm644 default.yaml           $out/share/rime-data
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
