{
  lib,
  pkgs,
  config,
  username,
  ...
}:
let
  cfg = config.mods.kde;
in
{
  options.mods.kde = {
    enable = lib.mkEnableOption ''
      my kde customize.
    '';
  };

  config = lib.mkIf cfg.enable {

    mods.fcitx.enable = true;

    services = {
      colord.enable = true;
      geoclue2.enable = true;

      desktopManager.plasma6.enable = true;
      displayManager.autoLogin.user = "${username}";
      displayManager.sddm = {
        enable = true;
        wayland.enable = true;
      };
    };

    programs = {
      kdeconnect.enable = true;
      partition-manager.enable = true;
    };

    environment.systemPackages =
      with pkgs;
      [
        merkuro
        yakuake
        gparted
        kcolorchooser
      ]
      ++ (with kdePackages; [
        kalk
        krfb
        krdc
        kgamma # broken?
        ksystemlog
        kmousetool
        # kleopatra
        # konqueror
        # kcontacts
        # korganizer
        sddm-kcm
      ]);

    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      # elisa
      # khelpcenter
      # print-manager
      plasma-browser-integration
    ];
  };
}
