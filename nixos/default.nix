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
      ./modules/doas.nix
      ./modules/fcitx.nix
      ./modules/flatpak.nix
      ./modules/clash-for-windows.nix
    ];
  };
}
