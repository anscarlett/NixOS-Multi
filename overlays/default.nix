final: prev: {
  # scripts
  nixos-helper = prev.callPackage ./nixos-helper {};
  getip = prev.callPackage ./getip {};
  forgit = prev.callPackage ./forgit {};
  wifi-qr = prev.callPackage ./wifi-qr {};

  # rust
  gnome-decoder = prev.callPackage ./gnome-decoder {};
  artem = prev.callPackage ./artem {};
  pbcli = prev.callPackage ./pbcli {};
  clitrans = prev.callPackage ./clitrans {};
  pidif = prev.callPackage ./pidif {};
  qr-rs = prev.callPackage ./qr-rs {};
  mprober = prev.callPackage ./mprober {};
  app-icon-preview = prev.callPackage ./app-icon-preview {};
  netease-cloud-music-gtk = prev.callPackage ./netease-cloud-music-gtk {};
  video-trimmer = prev.callPackage ./video-trimmer {};
  code-radio-cli = prev.callPackage ./code-radio-cli {};
  image-roll = prev.callPackage ./image-roll {};

  # go
  v2raya = prev.callPackage ./v2raya {};
  eget = prev.callPackage ./eget {};

  # python
  dynamic-wallpaper = prev.callPackage ./dynamic-wallpaper {};
  gpu-viewer = prev.callPackage ./gpu-viewer {};

  # nodejs
  clash-verge = prev.callPackage ./clash-verge {};

  # gtk
  dippi = prev.callPackage ./dippi {};
  paper = prev.callPackage ./paper {};

  # qt
  mangareader = prev.libsForQt5.callPackage ./mangareader {};
  converseen = prev.libsForQt5.callPackage ./converseen {};
  opentodolist = prev.libsForQt5.callPackage ./opentodolist {};
  downzemall = prev.callPackage ./downzemall {};

  # libraries
  collision = prev.callPackage ./collision {};

  #############################################

  # Override
  # fix .desktop missing
  wl-color-picker =
    prev.wl-color-picker.overrideAttrs
    (oldAttrs: {
      postFixup = ''
        cp -r $out/usr/share $out/share '';
    });

  # libadwaita-git = prev.libadwaita.overrideAttrs (oldAttrs: {
  #   src = prev.fetchFromGitLab {
  #     domain = "gitlab.gnome.org";
  #     owner = "GNOME";
  #     repo = "libadwaita";
  #     rev = "0475afa54ee12fc1f691102c8186c7fc06fcd357";
  #     hash = "sha256-3ESu34HhsycVV2QNtcxfP7YffCGddKqLTtIkzeJc+GE=";
  #   };
  # });

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
  #       inherit src;
  #       outputHash = "sha256-YJ4Qva4keOk9aBPFwztkTpvS7uv7zl6TOHqYZzZEGAs=";
  #     });
  # });

  # gdm bug
  # gnome = prev.gnome.overrideScope' (gfinal: gprev: {
  #   gdm = gprev.gdm.overrideAttrs (oldAttrs: {
  #     src = prev.fetchurl {
  #       url = "https://gitlab.gnome.org/GNOME/gdm/-/archive/main/gdm-main.tar.gz";
  #       sha256 = "sha256-4Lsfg65HlHDyh0JQKmvFkRSFseYIv1QfEvTp3USLJi0=";
  #     };
  #   });
  # });

  # gnome = prev.gnome.overrideScope' (gfinal: gprev: {
  #   mutter = gprev.mutter.overrideAttrs (oldAttrs: rec {
  #     dynamic-buffering = prev.fetchurl {
  #       url = "https://gitlab.gnome.org/GNOME/mutter/-/merge_requests/2487.patch";
  #       sha256 = "sha256-KVerFwEgLaEpp5lFofX7VnbBPP4dIVm3+odVUZ8clYA=";
  #     };
  #     patches = dynamic-buffering;
  #   });
  # });

  # sddm-git
  # libsForQt5 = prev.libsForQt5.overrideScope' (finay: prevy: {
  #   sddm =
  #     prevy.sddm.overrideAttrs
  #     (oldAttrs: {
  #       src = prev.fetchFromGitHub {
  #         owner = "sddm";
  #         repo = "sddm";
  #         rev = "e67307e4103a8606d57a0c2fd48a378e40fcef06";
  #         sha256 = "sha256-FfbYQrHndU7rtI8CKK7wtn3pdufBSiXUgefozCja4Do=";
  #       };
  #       patches = [];
  #     });
  # });
}
