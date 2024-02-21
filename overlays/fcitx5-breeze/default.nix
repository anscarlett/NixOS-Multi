{
  lib,
  fetchFromGitLab,
  stdenvNoCC,
  python3,
  inkscape,
}:

stdenvNoCC.mkDerivation rec {
  pname = "fcitx5-breeze";
  version = "3.1.0";

  src = fetchFromGitLab {
    owner = "scratch-er";
    repo = "fcitx5-breeze";
    rev = "v${version}";
    hash = "sha256-rWDEKCz4saSHJER61KFhrlSHcQTdJNVgRIkT3K4mwhc=";
  };

  nativeBuildInputs = [
    python3
    inkscape
  ];

  installPhase = ''
    mkdir -p $out/share/fcitx5/themes
    python build.py
    ./install.sh $out
  '';

  meta = {
    description = "Fcitx5 theme to match KDE's Breeze style";
    homepage = "https://gitlab.com/scratch-er/fcitx5-breeze";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ zendo ];
  };
}
