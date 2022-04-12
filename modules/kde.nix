{
  config,
  pkgs,
  ...
}: {
  services.xserver.enable = true;
  services.xserver.desktopManager.plasma5 = {
    enable = true;
    supportDDC = true;
    # useQtScaling = true;
    runUsingSystemd = true;
  };

  services.xserver.displayManager = {
    # sddm.enable = true; # wayland bug
    lightdm.enable = true;
    lightdm.greeters.gtk.extraConfig = ''
      xft-dpi=240
    '';
    defaultSession = "plasmawayland";
    autoLogin.user = "iab";
  };

  # services.gnome.gnome-keyring.enable = true;
  # security.pam.services.login.enableGnomeKeyring = true;
  # programs.seahorse.enable = true;

  services.colord.enable = true;
  services.geoclue2.enable = true;

  programs.kdeconnect.enable = true;
  programs.partition-manager.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "qt";
  };

  environment.systemPackages = with pkgs; [
    libsForQt5.ark
    libsForQt5.kate
    libsForQt5.kcalc
    libsForQt5.kweather
    libsForQt5.kde-gtk-config
    # libsForQt5.kgamma5          # not work

    libsForQt5.krdc
    libsForQt5.kleopatra
    # libsForQt5.konqueror
    # libsForQt5.kcontacts
    # libsForQt5.korganizer
    libsForQt5.bismuth # tiling layout

    falkon
    nheko
    kalendar
    yakuake
    gparted
    kcolorchooser
  ];

  services.tlp = {
    enable = true;
    settings = {
      cpu_scaling_governor_on_ac = "performance";
      cpu_scaling_governor_on_bat = "powersave";
      cpu_energy_perf_policy_on_ac = "balance_performance";
      cpu_energy_perf_policy_on_bat = "power";

      DEVICES_TO_ENABLE_ON_STARTUP = "wifi bluetooth";
    };
  };

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-rime
      # fcitx5-chinese-addons
    ];
  };
}
