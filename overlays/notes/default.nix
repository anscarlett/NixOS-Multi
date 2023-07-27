{ lib
, stdenv
, fetchFromGitHub
, cmake
, wrapQtAppsHook
, wrapGAppsHook
, qtbase
, qtdeclarative
, libpng
, appstream-glib
, wayland
, qtwayland
, qtsvg
, adwaita-qt6
, adwaita-qt
, qttools
, hicolor-icon-theme
, gnome
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "notes";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "nuttyartist";
    repo = "notes";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ZfAm77UHyjs2aYOYb+AhKViz6uteb7+KKSedonSiMkY=";
    fetchSubmodules = true;
  };

  cmakeFlags = [ "-DUPDATE_CHECKER=OFF" ];

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
    # wrapGAppsHook
    # appstream-glib
  ];

  buildInputs = [
    qtbase
    qtdeclarative
    # libpng
    # hicolor-icon-theme
    # wayland
    # qtwayland
    # qtsvg
    # adwaita-qt6
    # adwaita-qt
    # gnome.adwaita-icon-theme
    # qttools
    # qqc2-desktop-style
  ];

  postInstall = ''
    # fix for gnome
    substituteInPlace $out/share/applications/io.github.nuttyartist.notes.desktop \
       --replace 'Exec=notes' 'Exec=env QT_STYLE_OVERRIDE= notes'
  '';

  meta = with lib; {
    description = "A fast and beautiful note-taking app";
    homepage = "https://www.get-notes.com";
    downloadPage = "https://github.com/nuttyartist/notes";
    license = licenses.mpl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ zendo ];
  };
})
