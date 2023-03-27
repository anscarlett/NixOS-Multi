{
  lib,
  pkgs,
  config,
  ...
}: {
  options.services.my-flatpak = {
    enable = lib.mkEnableOption (lib.mdDoc ''
      my flatpak customize.
    '');
  };

  config = lib.mkIf config.services.my-flatpak.enable {
    services.flatpak.enable = true;

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
            paths = config.fonts.fonts;
            pathsToLink = ["/share/fonts"];
          }
          + "/share/fonts";
      };
  };
}
