{ lib
, stdenv
, fetchFromGitLab
, cmake
, extra-cmake-modules
, kirigami2
, qtwebkit
, qtwebengine
, qtquickcontrols2
, wrapQtAppsHook
, qtbase
, qttools
, kcoreaddons
, pkg-config
, kconfig
, ki18n
}:

stdenv.mkDerivation rec {
  pname = "klever";
  version = "unstable-2023-02-18";

  src = fetchFromGitLab {
    owner = "schul9louis";
    repo = "klever";
    rev = "7f4faab29cc5f9faaaa275ed320dac0c8ef01c5a";
    hash = "sha256-XU7HfP89M7IdAqOONUUh1Any4RzxY6yuLyG5F7gLV9A=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    wrapQtAppsHook
  ];

  buildInputs = [
    # qtbase
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
