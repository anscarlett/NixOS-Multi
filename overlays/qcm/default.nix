{ lib
, stdenv
, fetchFromGitHub
, cmake
, wrapQtAppsHook
, openssl
, curl
, qtsvg
, qtbase
, qttools
, qtmultimedia
, qtwayland
, gst_all_1
}:
# WIP!!!
stdenv.mkDerivation rec {
  pname = "qcm";
  version = "unstable-2023-03-22";

  src = fetchFromGitHub {
    owner = "hypengw";
    repo = "Qcm";
    fetchSubmodules = true;
    rev = "dc1927f2de090202f714ce9a660879a20e039a84";
    hash = "sha256-XOkGDWrSQxfOjhuWx82fNhoxuL0WpNF/iarFrFvuuJo=";
  };

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
  ];

  buildInputs = [
    openssl
    curl
    qtsvg
    qtbase
    qttools
    qtmultimedia
    # qtwayland
  ];

  meta = with lib; {
    description = "Qt client for netease cloud music";
    homepage = "https://github.com/hypengw/Qcm";
    mainProgram = "Qcm";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
