final: prev: {
  /*
  nix build --impure --expr 'with import <nixpkgs> {}; callPackage ./default.nix {}' -L
  nix build --impure --expr 'with import <nixpkgs> {}; callPackage ./default.nix {}' -L \
  -I $HOME/nsworld # ???
  -I nixpkgs=flake:github:NixOS/nixpkgs/nixos-22.05
  -I nixpkgs=flake:github:NixOS/nixpkgs/$(nixos-version --revision)
  */

  spotify = prev.callPackage ./spotify {};
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
  pythonPackagesOverlays =
    (prev.pythonPackagesOverlays or [])
    ++ [
      (python-final: python-prev: {
        pyjokes = python-final.callPackage ./python-modules/pyjokes {};
      })
    ];
  python3 = let
    self = prev.python3.override {
      inherit self;
      packageOverrides = prev.lib.composeManyExtensions final.pythonPackagesOverlays;
    };
  in
    self;
  python3Packages = final.python3.pkgs;

  # Java

  # flutter
  fclash = prev.callPackage ./fclash {};

  ############# Override ###################
  # fix .desktop missing
  wl-color-picker =
    prev.wl-color-picker.overrideAttrs
    (oldAttrs: {
      postFixup = ''
        cp -r $out/usr/share $out/share '';
    });

  logseq-wayland = prev.symlinkJoin {
    name = "logseq";
    paths = [prev.logseq];
    nativeBuildInputs = [prev.makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/logseq \
        --add-flags "--socket=wayland --enable-features=UseOzonePlatform --ozone-platform=wayland"
    '';
  };

  # libsForQt5 override
  libsForQt5 = prev.libsForQt5.overrideScope' (finay: prevy: {
    sddm = prevy.sddm.overrideAttrs (oldAttrs: {
      src = prev.fetchFromGitHub {
        owner = "sddm";
        repo = "sddm";
        rev = "b923eccba2b8a3b8f6bf63fca10b4ff88b4b5f7a";
        sha256 = "sha256-zbTr3IXVvtZqEFimG6GBjxLyPi2UoyIFKaqiaefCPTo=";
      };
      patches = [];
      cmakeFlags =
        oldAttrs.cmakeFlags
        ++ [
          "-DSYSTEMD_SYSUSERS_DIR=${placeholder "out"}/lib/sysusers.d"
          "-DSYSTEMD_TMPFILES_DIR=${placeholder "out"}/lib/tmpfiles.d"
        ];
    });
  });

  gnomeExtensions = prev.gnomeExtensions // {
    night-theme-switcher = prev.callPackage ./night-theme-switcher {};
  };

  /*
  # node override
  nodePackages = nodePackages.extend (final: prev: { });

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

  # gnome override
  gnome = prev.gnome.overrideScope' (gfinal: gprev: {
  mutter = gprev.mutter.overrideAttrs (oldAttrs: rec {
    dynamic-buffering = prev.fetchurl {
      url = "https://gitlab.gnome.org/GNOME/mutter/-/merge_requests/2487.patch";
      sha256 = "sha256-KVerFwEgLaEpp5lFofX7VnbBPP4dIVm3+odVUZ8clYA=";
    };
    patches = dynamic-buffering;
  });
  });
  */
}
