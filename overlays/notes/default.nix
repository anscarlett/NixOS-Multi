{ lib
, stdenv
, fetchFromGitHub
, cmake
, wrapQtAppsHook
, qtbase
}:

stdenv.mkDerivation rec {
  pname = "notes";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "nuttyartist";
    repo = "notes";
    fetchSubmodules = true;
    rev = "v${version}";
    hash = "sha256-pTRcXVwtH4gxxFIkJaqbuk6SOiC879oYxFgQyFBaQAc=";
  };

  cmakeFlags = [ "-DUPDATE_CHECKER=OFF" ];

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
  ];

  meta = with lib; {
    description = "Fast and beautiful note-taking app, Write down your thoughts";
    homepage = "https://www.get-notes.com";
    license = licenses.mpl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
