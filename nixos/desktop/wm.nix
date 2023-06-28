{
  pkgs,
  username,
  ...
}: {
  mods.fcitx.enable = true;

  services = {
    xserver = {
      # for X11
      enable = true;
      xkbOptions = "ctrl:swapcaps";
      # use greetd
      displayManager.lightdm.enable = false;
    };
    greetd.enable = true; # displayManager

    gvfs.enable = true; # (webkitgtk)
    upower.enable = true;
    blueman.enable = true;
    geoclue2.enable = true;
  };

  programs = {
    light.enable = true;
    # gtklock.enable = true;
    evince.enable = true;
    file-roller.enable = true;

    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
  };

  # If using wm@hm
  security.pam.services.swaylock = {};
  programs.dconf.enable = true;
  programs.xwayland.enable = true;

  environment.pathsToLink = [
    "/share/fcitx5" # for fxitx skins
  ];

  environment.sessionVariables = {
    GTK_USE_PORTAL = "1";
    # GDK_BACKEND = "wayland";
    # WLR_DRM_NO_ATOMIC = "1";
    # WLR_NO_HARDWARE_CURSORS = "1";
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [xdg-desktop-portal-gtk];
  };

  home-manager.users.${username} = {
    config,
    pkgs,
    ...
  }: {
    home.packages = with pkgs; [
      swappy # screenshot annotation editor
      swaybg # wallpaper tool
      swayidle
      swaylock-effects
      swaynotificationcenter
      # mako  # , notify-send "sth"
      libnotify # notify-send
      wlogout

      wofi # quick run
      wofi-emoji
      wl-clipboard
      wf-recorder
      cliphist
      networkmanagerapplet
      bluetuith
      blueberry
      wlopm
      wev # wayland event view
      wvkbd # on-screen keyboard
      # waypipe # proxy ?
      # wtype # xdotool

      # Display
      brightnessctl # same like light
      wlsunset # nightlight
      wl-gammactl
      wdisplays
      wlr-randr
      kanshi # autorandr

      # Media
      # grim # grab image
      # slurp # select region
      shotman
      pavucontrol
      playerctl # media player control
      pamixer # volume control

      # Needs when use other DM
      gnome.adwaita-icon-theme
      gnome.gnome-themes-extra
      gnome.dconf-editor
      gnome.gnome-tweaks # (webkitgtk)

      xfce.mousepad
      nomacs
      # gnome.gnome-power-manager
      # gnome.gnome-characters
      # gnome.eog
      # gthumb
      # libsForQt5.gwenview
      gparted
    ];

    services = {
      avizo.enable = true;
      udiskie.enable = true;
      gnome-keyring.enable = true;
      # playerctld.enable = true;
      polkit.enable = true;

      wlsunset = {
        enable = true;
        # gama = "2.0";
        latitude = "22.2783";
        longitude = "114.1747";
      };
    };

    qt = {
      enable = true;
      platformTheme = "gnome";
      style.package = pkgs.adwaita-qt;
      style.name = "adwaita";
    };

    # Fix tiny cursor
    home.pointerCursor = {
      name = "Vanilla-DMZ-AA";
      package = pkgs.vanilla-dmz;
      size = 128;
      # name = "Bibata-Modern-Classic";
      # package = pkgs.bibata-cursors;
      # size = 128;
    };
  };
}
