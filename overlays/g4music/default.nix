{ lib
, stdenv
, fetchFromGitLab
, vala
, meson
, ninja
, pkg-config
, glib
, gtk4
, libadwaita
, dbus
, tracker
, taglib
, gst_all_1
, pipewire
, wrapGAppsHook4
, appstream-glib
, desktop-file-utils
}:

stdenv.mkDerivation rec {
  pname = "g4music";
  version = "1.9.2";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "neithern";
    repo = pname;
    # rev = "v${version}";
    rev = "6517331605cc6fcf3ebbba3f2492cfc52bd29b69";
    hash = "sha256-6z72WvbATJr92IghurZ6kyZQX0Xjnn6lTPhc7+33RHw=";
  };

  # patches = [ ./data-meson-build.patch ];

  nativeBuildInputs = [
    vala
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
    dbus
    # tracker
    taglib
    pipewire
  ] ++ (with gst_all_1; [
    gstreamer
    gst-libav
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-plugins-ugly
  ]);

  meta = with lib; {
    description = "A beautiful, fast, fluent, light weight music player";
    homepage = "https://gitlab.gnome.org/neithern/g4music";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
