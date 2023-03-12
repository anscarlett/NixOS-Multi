{ lib
, stdenv
, fetchFromGitLab
, cmake
, extra-cmake-modules
, wrapQtAppsHook
, kio
, ki18n
, kconfig
, kcoreaddons
, kirigami2
, qtwebengine
, qtquickcontrols2
}:

stdenv.mkDerivation rec {
  pname = "klever";
  version = "unstable-2023-02-18";

  src = fetchFromGitLab {
    owner = "schul9louis";
    repo = "klever";
    rev = "17982ed13ef84a2bcbe9717e2c51db30121ab87f";
    hash = "sha256-8fw9TNiuq7R8liO8tQTqycNM3uiIcZxFlwoM9ufFlSs=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    wrapQtAppsHook
  ];

  buildInputs = [
    # qtbase
    kio
    ki18n
    kconfig
    kcoreaddons
    kirigami2
    qtwebengine
    qtquickcontrols2
  ];

  meta = with lib; {
    description = "A convergent markdown note taking application using Kirigami/QML";
    homepage = "https://gitlab.com/schul9louis/klever";
    license = with licenses; [ ];
    maintainers = with maintainers; [ zendo ];
  };
}
