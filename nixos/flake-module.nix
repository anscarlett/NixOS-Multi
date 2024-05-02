{
  flake.nixosModules = {
    default = {
      imports = [
        ./base.nix
        ./user.nix
        ./sound.nix
        ./fonts.nix
        ./nixconfig.nix
        ./networking.nix
        ./nix-ld.nix
        ./mods/dae.nix
        ./mods/doas.nix
        ./mods/fcitx.nix
        ./mods/steam.nix
        ./mods/clash-verge.nix
        ./mods/virtualisation.nix
        ../secrets/secrets.nix
      ];
    };

    gnome = {
      imports = [ ./desktop/gnome.nix ];
    };

    kde = {
      imports = [ ./desktop/kde.nix ];
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
  };
}
