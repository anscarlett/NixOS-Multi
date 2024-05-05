{ self, ... }:
{
  flake.nixosModules = {
    default = {
      imports = self.lib.umport {
        path = ./.;
        exclude = [
          ./flake-module.nix
        ];
      };

      # imports = [
      #   ./base.nix
      #   ./fonts.nix
      #   ./networking.nix
      #   ./nix-ld.nix
      #   ./nixconfig.nix
      #   ./sound.nix
      #   ./user.nix
      #   ./secrets/secrets.nix
      #   ./mods/clash-verge.nix
      #   ./mods/dae.nix
      #   ./mods/doas.nix
      #   ./mods/fcitx.nix
      #   ./mods/steam.nix
      #   ./mods/virtualisation.nix
      #   ./desktop/gnome.nix
      #   ./desktop/kde.nix
      #   ./desktop/server.nix
      #   ./desktop/wm-hyprland.nix
      #   ./desktop/wm-sway.nix
      #   ./desktop/wm.nix
      # ];
    };
  };
}
