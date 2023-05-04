{ lib
, stdenv
, fetchFromGitLab
, ninja
, pkg-config
, wrapGAppsHook
, fontconfig
, freetype
, libpng
, libwebp
, libheif
, libtiff
, libX11
, libXext
, libXcursor
}:

stdenv.mkDerivation rec {
  pname = "azcomicv";
  version = "2.0.6";

  src = fetchFromGitLab {
    owner = "azelpg";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ChcR8Gf3AdM4YuSt2ip7SUdsd7l3lgCXmnPXGul5rIg=";
  };

  nativeBuildInputs = [
    ninja
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    fontconfig
    freetype
    libpng
    libwebp
    libheif
    libtiff
    libX11
    libXext
    libXcursor
  ];

  buildPhase = ''
    cd build
    ninja
    ninja install
  '';

  meta = with lib; {
    description = "A simple comic reader";
    homepage = "http://azsky2.html.xdomain.jp/soft/index.html";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
