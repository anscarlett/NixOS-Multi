{
  default = {
    imports = [
      ./base.nix
      ./user.nix
      ./sound.nix
      ./fonts.nix
      ./nixconfig.nix
      ./networking.nix
      ./mods/virt.nix
      ./mods/doas.nix
      ./mods/fcitx.nix
      ./mods/flatpak.nix
      ./mods/clash-nyanpasu.nix
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
