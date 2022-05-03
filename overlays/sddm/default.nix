{ mkDerivation, lib, fetchFromGitHub, fetchpatch
, cmake, extra-cmake-modules, pkg-config, libxcb, libpthreadstubs
, libXdmcp, libXau, qtbase, qtdeclarative, qtquickcontrols2, qttools, pam, systemd
}:

mkDerivation {
  pname = "sddm";

  src = fetchFromGitHub {
    owner = "sddm";
    repo = "sddm";
    rev = "e67307e4103a8606d57a0c2fd48a378e40fcef06";
    sha256 = "1s6icb5r1n6grfs137gdzfrcvasb3hvlhib2zh6931x8pkl1qvxa";
  };

  patches = [
    ./sddm-ignore-config-mtime.patch
    ./sddm-default-session.patch
    # Load `/etc/profile` for `environment.variables` with zsh default shell.
    # See: https://github.com/sddm/sddm/pull/1382
    (fetchpatch {
      url = "https://github.com/sddm/sddm/commit/e1dedeeab6de565e043f26ac16033e613c222ef9.patch";
      sha256 = "sha256-OPyrUI3bbH+PGDBfoL4Ohb4wIvmy9TeYZhE0JxR/D58=";
    })
    # Fix build with Qt 5.15.3
    # See: https://github.com/sddm/sddm/pull/1325
    (fetchpatch {
      url = "https://github.com/sddm/sddm/commit/e93bf95c54ad8c2a1604f8d7be05339164b19308.patch";
      sha256 = "sha256:1rh6sdvzivjcl5b05fczarvxhgpjhi7019hvf2gadnwgwdg104r4";
    })
  ];

  postPatch =
    # Fix missing include for gettimeofday()
    ''
      sed -e '1i#include <sys/time.h>' -i src/helper/HelperApp.cpp
    '';

  nativeBuildInputs = [ cmake extra-cmake-modules pkg-config qttools ];

  buildInputs = [
    libxcb libpthreadstubs libXdmcp libXau pam qtbase qtdeclarative qtquickcontrols2 systemd
  ];

  cmakeFlags = [
    "-DCONFIG_FILE=/etc/sddm.conf"
    # Set UID_MIN and UID_MAX so that the build script won't try
    # to read them from /etc/login.defs (fails in chroot).
    # The values come from NixOS; they may not be appropriate
    # for running SDDM outside NixOS, but that configuration is
    # not supported anyway.
    "-DUID_MIN=1000"
    "-DUID_MAX=29999"

    "-DQT_IMPORTS_DIR=${placeholder "out"}/${qtbase.qtQmlPrefix}"
    "-DCMAKE_INSTALL_SYSCONFDIR=${placeholder "out"}/etc"
    "-DSYSTEMD_SYSTEM_UNIT_DIR=${placeholder "out"}/lib/systemd/system"
    "-DDBUS_CONFIG_DIR=${placeholder "out"}/share/dbus-1/system.d"
  ];

  postInstall = ''
    # remove empty scripts
    rm "$out/share/sddm/scripts/Xsetup" "$out/share/sddm/scripts/Xstop"
    for f in $out/share/sddm/themes/**/theme.conf ; do
      substituteInPlace $f \
        --replace 'background=' "background=$(dirname $f)/"
    done
  '';

  meta = with lib; {
    description = "QML based X11 display manager";
    homepage    = "https://github.com/sddm/sddm";
    maintainers = with maintainers; [ abbradar ttuegel ];
    platforms   = platforms.linux;
    license     = licenses.gpl2Plus;
  };
}
