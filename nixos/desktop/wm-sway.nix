{
  lib,
  pkgs,
  config,
  username,
  ...
}:
let
  cfg = config.mods.sway;
in
{
  options.mods.sway = {
    enable = lib.mkEnableOption ''
      my sway customize.
    '';
  };

  config = lib.mkIf cfg.enable {

    mods.wm.enable = true;

    # DisplayManager
    services.greetd = {
      enable = true;
      settings = {
        default_session.command = "${lib.getExe pkgs.greetd.tuigreet} --time --cmd sway";
        # Autologin
        initial_session = {
          command = "sway";
          user = "${username}";
        };
      };
    };

    home-manager.users.${username} = {
      wayland.windowManager.sway = {
        enable = true;
        wrapperFeatures.gtk = true;
        config = null;
        extraConfig = ''
          include ./custom.conf
        '';
        # extraSessionCommands = ''
        #   export XDG_CURRENT_DESKTOP="sway"
        # '';
      };

      home.packages = with pkgs; [
        swayr
        autotiling-rs
      ];
    };
  };
}
