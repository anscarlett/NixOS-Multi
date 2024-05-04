{
  lib,
  pkgs,
  config,
  username,
  ...
}:
let
  cfg = config.mods.hyprland;
in
{
  options.mods.hyprland = {
    enable = lib.mkEnableOption ''
      my hyprland customize.
    '';
  };

  config = lib.mkIf cfg.enable {

    mods.wm.enable = true;

    # DisplayManager
    services.greetd = {
      enable = true;
      settings = {
        default_session.command = "${lib.getExe pkgs.greetd.tuigreet} --time --cmd Hyprland";
        # Autologin
        initial_session = {
          command = "Hyprland";
          user = "${username}";
        };
      };
    };

    home-manager.users.${username} = {
      wayland.windowManager.hyprland = {
        enable = true;
        extraConfig = ''
          source=./custom.conf
        '';
      };

      home.packages = with pkgs; [
        # hyprpaper # wallpaper
        hyprpicker
        hyprlock
      ];
    };
  };
}
