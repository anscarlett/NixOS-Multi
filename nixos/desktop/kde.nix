{
  pkgs,
  ...
}: {
  mods.fcitx.enable = true;

  services = {
    colord.enable = true;
    geoclue2.enable = true;
  };

  programs = {
    dconf.enable = true;
    kdeconnect.enable = true;
    partition-manager.enable = true;
  };

  # services.gnome.gnome-keyring.enable = true;
  # security.pam.services.login.enableGnomeKeyring = true;
  # programs.seahorse.enable = true;

  environment.systemPackages = with pkgs;
    [
      # falkon
      kalendar
      yakuake
      gparted
      # latte-dock
      kcolorchooser
      gnome.gnome-color-manager # broken?
    ]
    ++ (with libsForQt5; [
      ark
      juk
      kate
      kalk
      krfb
      krdc
      kgamma5 # broken?
      kweather
      ksystemlog
      kmousetool
      # kleopatra
      # konqueror
      # kcontacts
      # korganizer
    ]);

  environment.plasma5.excludePackages = with pkgs.libsForQt5; [
    # elisa
    # oxygen
    # khelpcenter
    # print-manager
    plasma-browser-integration
  ];

  services.xserver = {
    enable = true;
    excludePackages = [pkgs.xterm];
    displayManager = {
      defaultSession = "plasmawayland";

      sddm = {
        enable = true;
        wayland.enable = true;
      };

      lightdm = {
        enable = false;
        greeters.gtk = {
          cursorTheme.size = 48;
          extraConfig = ''
            xft-dpi=261
            clock-format=%H:%M
          '';
          indicators = [
            "~spacer"
            "~clock"
            "~spacer"
            "~session"
            # "~language"
            # "~a11y"
            "~power"
          ];
        };
      };
    };

    desktopManager.plasma5 = {
      enable = true;
      # useQtScaling = true;
    };
  };
}
