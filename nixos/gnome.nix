{
  pkgs,
  ...
}: {
  services = {
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      excludePackages = [pkgs.xterm];
    };

    packagekit.enable = false;
    gnome.sushi.enable = true;
    # gnome.tracker.enable = false;
    # gnome.tracker-miners.enable = false;
  };

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome.yelp
    gnome.geary
    gnome.totem
    gnome-photos
    gnome.baobab
    gnome.gnome-music
    gnome.gnome-software
  ];

  environment.systemPackages = with pkgs;
    [
      gthumb
      # authenticator
      gparted
      gnome-randr

      gnome.gnome-tweaks
      gnome.dconf-editor
      gnome.gnome-power-manager
      gnome.gnome-sound-recorder
      # gnome.pomodoro
      # gnome.gnome-boxes
      # gnome-network-displays  # miracast
      # gnome-builder
      # gnome-firmware-updater
    ]
    ++ (with gnomeExtensions; [
      app-hider
      appindicator
      app-icons-taskbar
      # rocketbar
      dash-to-dock
      # dash-to-panel
      # dock-from-dash
      night-theme-switcher
      clipboard-history
      # clipboard-indicator
      # blur-my-shell
      gradient-top-bar
      top-bar-organizer
      # weather-oclock
      # proxy-switcher
      # just-perfection
      space-bar
      # dotspaces
      runcat
      caffeine
      # ddterm
      improved-osk
    ]);

  programs.kdeconnect = {
    enable = true;
    package = pkgs.valent;
    # package = pkgs.gnomeExtensions.gsconnect;
  };

  # programs.my-fcitx.enable = true;

  i18n.inputMethod = {
    enabled = "ibus";
    ibus.engines = with pkgs.ibus-engines; [
      # libpinyin
      (rime.override {
        rimeDataPkgs = [pkgs.rime-ice];
      })
    ];
  };
}
