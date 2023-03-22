{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, wrapQtAppsHook
, openssl
, curl
, qtsvg
, qtbase
, qttools
, qtmultimedia
}:

stdenv.mkDerivation rec {
  pname = "qcm";
  version = "unstable-2023-03-22";

  src = fetchFromGitHub {
    owner = "hypengw";
    repo = "Qcm";
    fetchSubmodules = true;
    rev = "07b8fddee508bb65f1235c37238abc109d072fcb";
    hash = "sha256-q8TBYGAVhRJnP+w5oWPZrScv7KeuGc9/oqievI7Zbx4=";
  };

  nativeBuildInputs = [
    cmake
    # pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    openssl
    curl
    qtsvg
    qtbase
    qttools
    qtmultimedia
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
