{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, wrapGAppsHook4
, appstream-glib
, desktop-file-utils
, glib
, gtk4
, libadwaita
, jsoncpp
, yt-dlp
}:

stdenv.mkDerivation rec {
  pname = "tubeconverter";
  version = "2023.2.0";

  src = fetchFromGitHub {
    owner = "nlogozzo";
    repo = "NickvisionTubeConverter";
    rev = version;
    hash = "sha256-coIG49rBM30Sajb0mWsbL2OIi/2jGiiGCW/qPpdZm5o=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    appstream-glib
    desktop-file-utils
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    jsoncpp
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : "${lib.makeBinPath [ yt-dlp ]}"
    )
  '';

  meta = with lib; {
    description = "An easy-to-use video downloader";
    homepage = "https://github.com/nlogozzo/NickvisionTubeConverter";
    mainProgram = "org.nickvision.tubeconverter";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ zendo ];
  };
}
