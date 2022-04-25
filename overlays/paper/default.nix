{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  vala,
  cmake,
  libgee,
  glib,
  gtk4,
  gtksourceview5,
  libadwaita,
  wrapGAppsHook4,
  appstream-glib,
  desktop-file-utils,
}:
stdenv.mkDerivation rec {
  pname = "paper";
  version = "22.2";

  src = fetchFromGitLab {
    owner = "posidon_software";
    repo = pname;
    rev = "${version}";
    sha256 = "sha256-/yK+QHVP4gpz/9PDJaBGHHBta8hh1WLsnNtCVxlHA3g=";
  };

  nativeBuildInputs = [
    vala
    meson
    ninja
    cmake
    pkg-config
    appstream-glib
    desktop-file-utils
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    gtk4
    libgee
    libadwaita
    gtksourceview5
  ];

  meta = with lib; {
    homepage = "https://gitlab.com/posidon_software/paper";
    description = "A pretty markdown note-taking app for Gnome";
    maintainers = with maintainers; [zendo];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
