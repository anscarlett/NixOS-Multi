{
  default = {
    imports = [
      ./base.nix
      ./user.nix
      ./networking.nix
      ./nixconfig.nix
      ./sound.nix
      ./fonts.nix
      ./services/fcitx.nix
      ./services/clash-verge.nix
      ./services/clash-for-windows.nix
    ];
  };
}
