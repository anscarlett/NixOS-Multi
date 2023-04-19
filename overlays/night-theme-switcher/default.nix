{ lib
, stdenv
, fetchFromGitLab
, meson
, ninja
, pkg-config
, glib
}:

stdenv.mkDerivation rec {
  pname = "night-theme-switcher";
  version = "74";

  src = fetchFromGitLab {
    owner = "rmnvgr";
    repo = "nightthemeswitcher-gnome-shell-extension";
    rev = version;
    hash = "sha256-68TsKSZspa/hgQHje16EcNx0I9bg5ICiGAzqY71sPsI=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    glib
  ];

  mesonFlags = [
    "--datadir=${placeholder "out"}/share"
  ];

  meta = with lib; {
    description = "A GNOME Shell extension to make your desktop easy on the eye, day and night";
    homepage = "https://nightthemeswitcher.romainvigier.fr";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
