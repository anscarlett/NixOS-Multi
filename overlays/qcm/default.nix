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
    rev = "935070cabe38b91bdaf7a0ca93ca7e2a91d47556";
    hash = "sha256-UDn9e2fVIEy7tzaqPK4ecZhVniUHMwH8KFomHFIZ75s=";
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
    qtwayland
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
