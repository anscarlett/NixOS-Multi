{ pkgs, ... }:
{
  mods.fcitx.enable = true;

  services = {
    colord.enable = true;
    geoclue2.enable = true;
    desktopManager.plasma6.enable = true;
  };

  programs = {
    kdeconnect.enable = true;
    partition-manager.enable = true;
  };

  environment.systemPackages =
    with pkgs;
    [
      # falkon
      merkuro
      yakuake
      gparted
      # latte-dock
      kcolorchooser
    ]
    ++ (with kdePackages; [
      kalk
      krfb
      krdc
      kgamma # broken?
      kweather
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

  services.xserver = {
    enable = true;
    excludePackages = [ pkgs.xterm ];

    displayManager = {
      defaultSession = "plasma";

      sddm = {
        enable = true;
        wayland.enable = true;
      };
    };
  };
}
