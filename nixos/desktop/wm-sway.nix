{
  lib,
  pkgs,
  username,
  ...
}:
{
  imports = [ ./wm.nix ];

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
}
