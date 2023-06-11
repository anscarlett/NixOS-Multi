{ lib
, stdenv
, fetchFromGitHub
, cmake
, wrapQtAppsHook
, qtbase
, qtdeclarative
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "notes";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "nuttyartist";
    repo = "notes";
    fetchSubmodules = true;
    rev = "v${finalAttrs.version}";
    # rev = "5b76489d2f8bb5d4feb782e7049645e7676c8572";
    hash = "sha256-pTRcXVwtH4gxxFIkJaqbuk6SOiC879oYxFgQyFBaQAc=";
  };

  cmakeFlags = [ "-DUPDATE_CHECKER=OFF" ];

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    qtdeclarative
  ];

  meta = with lib; {
    description = "A fast and beautiful note-taking app";
    homepage = "https://www.get-notes.com";
    downloadPage = "https://github.com/nuttyartist/notes";
    license = licenses.mpl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ zendo ];
  };
})
