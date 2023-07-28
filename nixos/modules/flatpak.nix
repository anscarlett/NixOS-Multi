{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.mods.flatpak;
in {
  options.mods.flatpak = {
    enable = lib.mkEnableOption (lib.mdDoc ''
      my flatpak customize.
    '');
  };

  config = lib.mkIf cfg.enable {
    services.flatpak.enable = true;

    environment.shellAliases = {
      gg-flatpak = "flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo ; flatpak remote-modify flathub --url=https://mirror.sjtu.edu.cn/flathub";
    };

    # Fix flatpak tofu and icons.
    # https://github.com/accelbread/config-flake/blob/master/nixos/common/flatpak-fonts.nix
    system.fsPackages = [pkgs.bindfs];
    fileSystems =
      lib.mapAttrs
      (_: v:
        v
        // {
          fsType = "fuse.bindfs";
          options = ["ro" "resolve-symlinks" "x-gvfs-hide"];
        })
      {
        "/usr/share/icons".device = "/run/current-system/sw/share/icons";
        "/usr/share/fonts".device =
          pkgs.buildEnv
          {
            name = "system-fonts";
            paths = config.fonts.packages;
            pathsToLink = ["/share/fonts"];
          }
          + "/share/fonts";
      };
  };
}
