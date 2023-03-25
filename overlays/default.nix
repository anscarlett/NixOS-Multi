final: prev: {
  /*
  nix build --impure --expr 'with import <nixpkgs> {}; callPackage ./default.nix {}' -L
  nix build --impure --expr 'with import <nixpkgs> {}; callPackage ./default.nix {}' -L \
  -I $HOME/nsworld # ???
  -I nixpkgs=flake:github:NixOS/nixpkgs/nixos-22.05
  -I nixpkgs=flake:github:NixOS/nixpkgs/$(nixos-version --revision)
  */

  # clash-verge = prev.callPackage ./clash-verge {};

  # Data
  nixos-helper = prev.callPackage ./nixos-helper {};
  fcitx5-breeze = prev.callPackage ./fcitx5-breeze {};
  rime-ice = prev.callPackage ./rime-ice {};

  # electron ALL WIP!!!
  listen1 = prev.callPackage ./listen1 {};
  koodo-reader = prev.callPackage ./koodo-reader {};
  thorium-reader = prev.callPackage ./thorium-reader {};
  nightpdf = prev.callPackage ./nightpdf {};
  music-you = prev.callPackage ./music-you {};
  weektodo = prev.callPackage ./weektodo {};

  # deb / autoPatchelf
  he3 = prev.callPackage ./he3 {};
  xmind = prev.callPackage ./xmind {};
  ohmymd = prev.callPackage ./ohmymd {};
  clash-verge-source = prev.callPackage ./clash-verge-source {};
  clash-for-windows = prev.callPackage ./clash-for-windows {};
  clash-premium = prev.callPackage ./clash-premium {};

  # C
  azcomicv = prev.callPackage ./azcomicv {};
  ctpv = prev.callPackage ./ctpv {};

  # Rust
  sniffnet = prev.callPackage ./sniffnet {}; # iced
  conceal = prev.callPackage ./conceal {};

  # Go

  # Gtk
  g4music = prev.callPackage ./g4music {};

  # Qt
  nekoray = prev.libsForQt5.callPackage ./nekoray {};
  qcm = prev.qt6Packages.callPackage ./qcm {};

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

  # Ruby
  bashly = prev.callPackage ./bashly {};

  # flutter
  spotube = prev.callPackage ./spotube {}; # WIP!!!
  fclash = prev.callPackage ./fclash {};
  # https://github.com/ferraridamiano/ConverterNOW

  # Libraries
  # lib = prev.lib.extend (finalLib: prevLib:
  #   (import ../lib { inherit (prev) lib; })
  # );

  ############# Override ###################
  # fix .desktop missing
  wl-color-picker =
    prev.wl-color-picker.overrideAttrs
    (oldAttrs: {
      postFixup = ''
        cp -r $out/usr/share $out/share '';
    });

  # fix duplicate desktop shortcut in kde
  # emacs = prev.symlinkJoin {
  #   name = "emacs";
  #   paths = [ prev.emacs ];
  #   postBuild = ''
  #     rm $out/share/applications/emacsclient.desktop
  #   '';
  # };

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
        rev = "e07e805c21310572b4fecc810fd5610b1d3d03fd";
        sha256 = "sha256-CcUN2XnrJYDPYIiOJtU8QzQg4TniSJG686BHoCF1mfQ=";
      };
      patches = [];
      cmakeFlags = oldAttrs.cmakeFlags ++ [
        "-DSYSTEMD_SYSUSERS_DIR=${placeholder "out"}/lib/sysusers.d"
        "-DSYSTEMD_TMPFILES_DIR=${placeholder "out"}/lib/tmpfiles.d"
      ];
    });
  });

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
