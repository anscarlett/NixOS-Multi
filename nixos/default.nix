{
  default = {
    imports = [
      ./base.nix
      ./user.nix
      ./sound.nix
      ./fonts.nix
      ./networking.nix
      ./nixconfig.nix
      ./virtualisation.nix
      ./modules/fcitx.nix
      ./modules/clash-verge.nix
      ./modules/clash-for-windows.nix
    ];
  };
}
