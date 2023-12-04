{inputs, ...}: {
  # nur = inputs.nur.overlay;

  # stable-packages = final: _prev: {
  #   stable = import inputs.nixpkgs-stable {
  #     system = final.system;
  #     config.allowUnfree = true;
  #   };
  # };

  modifications = _: prev: {
    # fix .desktop missing
    wl-color-picker =
      prev.wl-color-picker.overrideAttrs
      (oldAttrs: {
        postFixup = ''
          cp -r $out/usr/share $out/share '';
      });

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

    # Combining overrideAttrs and override
    librime =
      (prev.librime.overrideAttrs
        (oldAttrs: {
          buildInputs =
            oldAttrs.buildInputs
            ++ [prev.luajit];
        }))
      .override {
        plugins = [prev.librime-lua];
      };

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

    # rust override
    # shadowsocks-rust = prev.shadowsocks-rust.overrideAttrs (oldAttrs: rec {
    #   version = "2022-06-27";
    #   src = prev.fetchFromGitHub {
    #     owner = "shadowsocks";
    #     repo = "shadowsocks-rust";
    #     rev = "a4955a198bdf6ab12e647b04180679dfef53fb0b";
    #     sha256 = "sha256-sJKuGQH5PBOcFOpks8sUaAWJlfg7aCv6YS9DWaEF3K4=";
    #   };
    #   cargoDeps = oldAttrs.cargoDeps.overrideAttrs (_: {
    #     inherit src;
    #     outputHash = "sha256-YJ4Qva4keOk9aBPFwztkTpvS7uv7zl6TOHqYZzZEGAs=";
    #   });
    # });
  };

  # This one brings our custom packages from the 'pkgs' directory
  # additions = final: _prev: import ../pkgs { pkgs = final; };

  default = final: prev: {
    /*
    nix build --impure --expr "(import <nixpkgs> {}).callPackage ./. {}" -L
    qt6Packages
    */

    # clash-verge = prev.callPackage ./clash-verge-source {};
    clash-nyanpasu = prev.callPackage ./clash-nyanpasu {};

    # Data
    ns-cli = prev.callPackage ./ns-cli {};
    rime-ice = prev.callPackage ./rime-ice {};
    librime-lua = prev.callPackage ./librime-lua {};
    fcitx5-breeze = prev.callPackage ./fcitx5-breeze {};

    # AppImage
    moonfm = prev.callPackage ./moonfm {};
    gitfiend = prev.callPackage ./gitfiend {};

    # deb / autoPatchelf
    he3 = prev.callPackage ./he3 {};
    xmind = prev.callPackage ./xmind {};

    # electron ALL WIP!!!
    listen1 = prev.callPackage ./listen1 {};
    nightpdf = prev.callPackage ./nightpdf {};
    weektodo = prev.callPackage ./weektodo {};
    music-you = prev.callPackage ./music-you {};
    koodo-reader = prev.callPackage ./koodo-reader {};
    thorium-reader = prev.callPackage ./thorium-reader {};

    # C
    azcomicv = prev.callPackage ./azcomicv {};

    # Rust

    # Go
    trzsz-go = prev.callPackage ./trzsz-go {};

    # Gtk

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

    # gnome extensions
    # gnomeExtensions =
    #   prev.gnomeExtensions
    #   // {
    #     night-theme-switcher = prev.callPackage ./night-theme-switcher {};
    #   };
  };
}
