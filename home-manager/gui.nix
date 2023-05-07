{
  lib,
  pkgs,
  config,
  nixosConfig,
  ...
}: let
  gnomeEnable = nixosConfig.services.xserver.desktopManager.gnome.enable;
in {
  home.packages = with pkgs; [
    # nightpdf
    # azcomicv
    # moonfm

    foot
    kitty
    alacritty

    # nheko
    # fractal-next
    # discord
    tdesktop # (webkitgtk)

    # Multimedia
    spotify
    # vlc
    # ffmpeg
    kooha
    qmmp
    # (deadbeef-with-plugins.override {
    #   plugins = with deadbeefPlugins; [mpris2];
    # })
    # amberol
    # audacious
    # rhythmbox
    goodvibes
    go-musicfox
    # mousai
    songrec
    # yt-dlp
    # media-downloader
    # eartag
    # tagger
    # jamesdsp
    # ciano
    # video-trimmer
    # spotiflyer

    # Image manipulation
    # shutter
    # pinta
    # yacreader
    contrast
    # font-manager # (webkitgtk)
    # gcolor3
    # wl-color-picker

    warp
    whatip
    remmina # (webkitgtk)
    gnome-decoder
    # motrix
    qbittorrent
    # deja-dup
    # rclone
    # rclone-browser
    # vorta
    # qalculate-gtk # scientific calculator
    # poedit    # translate .po file
    handlr # mime

    # OFFICE
    # libreoffice-fresh
    # drawio
    # rnote # handwritten note
    # foliate # (webkitgtk)
    # standardnotes
    # paper-note
    notes
    # endeavour
    ghostwriter
    # textpieces
    meld

    # HARDWARE TEST
    amdgpu_top
    nvtop-amd
    inxi
    lm_sensors
    lshw
    kmon # kernel modules
    hwinfo
    cpufetch
    usbutils
    dmidecode
    # glxinfo
    # libva-utils #vainfo
    # vulkan-tools
    cpufrequtils
    pciutils
    edid-decode
    read-edid
    xorg.xeyes

    # libinput
    wallutils # lsmon getdpi wayinfo
    wayland-utils
    # wdisplays # wlr
  ];

  services = {
    # diabsle on wm
    # easyeffects.enable = !config.services.wlsunset.enable;
  };

  programs.mpv = {
    enable = true;
    scripts = with pkgs.mpvScripts; [
      mpris
      # uosc
      inhibit-gnome
    ];
  };

  # programs.obs-studio = {
  #   enable = true;
  # };

  #######################################################################
  ##  Desktop Environment
  #######################################################################
  home.sessionVariables = {
    NIXOS_OZONE_WL = lib.mkDefault 1; # Electron wayland native
    _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
  };

  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
    };

    dataFile = {
      # Fix qt tiny cursor on gnome
      "icons/default/index.theme".text = lib.optionalString gnomeEnable ''
        [icon theme]
        Inherits=Adwaita
      '';
    };

    # mimeApps.enable = true;

    # desktopEntries = {
    #   spotify = {
    #     name = "Spotify";
    #     genericName = "Music Player";
    #     icon = "spotify-client";
    #     # env xwayland
    #     exec = "env NIXOS_OZONE_WL= spotify %U --force-device-scale-factor=2";
    #     terminal = false;
    #     categories = ["Application" "Music"];
    #   };
    # };
  };
}
