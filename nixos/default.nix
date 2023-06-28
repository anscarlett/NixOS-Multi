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

  gnome = {
    imports = [./desktop/gnome.nix];
  };

  kde = {
    imports = [./desktop/kde.nix];
  };

  sway = {
    imports = [
      ./desktop/wm.nix
      ./desktop/wm-sway.nix
    ];
  };

  hyprland = {
    imports = [
      ./desktop/wm.nix
      ./desktop/wm-hyprland.nix
    ];
  };
}
