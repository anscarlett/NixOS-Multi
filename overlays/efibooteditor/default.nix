{ lib
, stdenv
, fetchFromGitHub
, cmake
, qttools
, wrapQtAppsHook
, qt5compat
, qtbase
, qtsvg
, efivar
}:

stdenv.mkDerivation rec {
  pname = "efibooteditor";
  version = "1.1.6";

  src = fetchFromGitHub {
    owner = "Neverous";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-kzuhNgw764r/gmZRgyoJWdzftjllm06Sl8fZ0iOihKA=";
  };

  nativeBuildInputs = [
    cmake
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    qt5compat
    qtbase
    qtsvg
    efivar
  ];

  meta = with lib; {
    description = "Boot Editor for (U)EFI based systems";
    homepage = "https://github.com/Neverous/efibooteditor";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
