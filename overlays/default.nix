final: prev: {
  /*
  nix build --impure --expr "(import <nixpkgs> {}).callPackage ./. {}" -L
  nix build --impure --expr "(import <nixpkgs> {}).callPackage ./. {}" -L \
  -I $HOME/nsworld # works?
  -I nixpkgs=flake:github:NixOS/nixpkgs/nixos-22.05
  -I nixpkgs=flake:github:NixOS/nixpkgs/$(nixos-version --revision)
  */

  notes = prev.qt6Packages.callPackage ./notes {};

  # Data
  ns-cli = prev.callPackage ./ns-cli {};
  rime-ice = prev.callPackage ./rime-ice {};
  fcitx5-breeze = prev.callPackage ./fcitx5-breeze {};

  # AppImage
  moonfm = prev.callPackage ./moonfm {};

  # deb / autoPatchelf
  he3 = prev.callPackage ./he3 {};
  xmind = prev.callPackage ./xmind {};
  clash-verge-source = prev.callPackage ./clash-verge-source {};
  clash-for-windows = prev.callPackage ./clash-for-windows {};
  clash-premium = prev.callPackage ./clash-premium {};

  # electron ALL WIP!!!
  listen1 = prev.callPackage ./listen1 {};
  koodo-reader = prev.callPackage ./koodo-reader {};
  thorium-reader = prev.callPackage ./thorium-reader {};
  nightpdf = prev.callPackage ./nightpdf {};
  music-you = prev.callPackage ./music-you {};
  weektodo = prev.callPackage ./weektodo {};

  # C
  azcomicv = prev.callPackage ./azcomicv {};

  # Rust

  # Go

  # Gtk
  g4music = prev.callPackage ./g4music {};

  # Qt

  # Python

  # Python Module Overlays
  # pythonPackagesOverlays =
  #   (prev.pythonPackagesOverlays or [])
  #   ++ [
  #     (python-final: python-prev: {
  #       pyjokes = python-final.callPackage ./python-modules/pyjokes {};
  #     })
  #   ];
  # python3 = let
  #   self = prev.python3.override {
  #     inherit self;
  #     packageOverrides = prev.lib.composeManyExtensions final.pythonPackagesOverlays;
  #   };
  # in
  #   self;
  # python3Packages = final.python3.pkgs;

  # Java

  # flutter

  ############# Override ###################
  # fix .desktop missing
  wl-color-picker =
    prev.wl-color-picker.overrideAttrs
    (oldAttrs: {
      postFixup = ''
        cp -r $out/usr/share $out/share '';
    });

  # spotify = prev.callPackage ./spotify {};

  # xwayland env for inputMethod & native CSD
  spotify =
    prev.spotify.overrideAttrs
    (oldAttrs: {
      postFixup = ''
        substituteInPlace $out/share/applications/spotify.desktop \
          --replace "Exec=spotify %U" "Exec=env NIXOS_OZONE_WL= spotify %U --force-device-scale-factor=2"
      '';
    });

  # spotify = prev.spotify.override {
  #   deviceScaleFactor = 2.0;
  # };

  # wrapProgram $out/bin/telegram-desktop --set QT_QPA_PLATFORM xcb
  logseq-wayland = prev.symlinkJoin {
    name = "logseq";
    paths = [prev.logseq];
    nativeBuildInputs = [prev.makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/logseq \
        --add-flags "--socket=wayland --enable-features=UseOzonePlatform --ozone-platform=wayland"
    '';
  };

  /*
  # node override
  nodePackages = nodePackages.extend (final: prev: { });

  # gnome extensions
  gnomeExtensions =
    prev.gnomeExtensions
    // {
      night-theme-switcher = prev.callPackage ./night-theme-switcher {};
    };

  # sddm-git
  sddm = prev.sddm.overrideAttrs (oldAttrs: {
    src = prev.fetchFromGitHub {
      owner = "sddm";
      repo = "sddm";
      rev = "58a35178b75aada974088350f9b89db45f5c3800";
      sha256 = "sha256-lTfsMUnYu3E25FSrMDkh9gB5X2fC0a5rvpMnPph4k=";
    };
    patches = [];
    cmakeFlags =
      oldAttrs.cmakeFlags
      ++ [
        "-DSYSTEMD_SYSUSERS_DIR=${placeholder "out"}/lib/sysusers.d"
        "-DSYSTEMD_TMPFILES_DIR=${placeholder "out"}/lib/tmpfiles.d"
      ];
  });

  # rust override
  shadowsocks-rust = prev.shadowsocks-rust.overrideAttrs (oldAttrs: rec {
  version = "2022-06-27";
  src = prev.fetchFromGitHub {
    owner = "shadowsocks";
    repo = "shadowsocks-rust";
    rev = "a4955a198bdf6ab12e647b04180679dfef53fb0b";
    sha256 = "sha256-sJKuGQH5PBOcFOpks8sUaAWJlfg7aCv6YS9DWaEF3K4=";
  };
  cargoDeps = oldAttrs.cargoDeps.overrideAttrs (_: {
    inherit src;
    outputHash = "sha256-YJ4Qva4keOk9aBPFwztkTpvS7uv7zl6TOHqYZzZEGAs=";
  });
  });
  */
}
