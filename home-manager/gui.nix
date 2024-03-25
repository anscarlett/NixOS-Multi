{
  lib,
  pkgs,
  inputs,
  config,
  nixosConfig,
  ...
}:
{
  home.packages = with pkgs; [
    # nightpdf
    # azcomicv
    # moonfm

    kitty
    nurl
    nix-init
    # nixpkgs-review
    inputs.deploy-rs.packages.x86_64-linux.deploy-rs

    # nheko
    # fractal
    # discord
    tdesktop # (webkitgtk)

    # Multimedia
    spotify
    # muzika
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
    # qcm
    # netease-cloud-music-gtk
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
    # downonspot

    # Image manipulation
    # shutter
    # pinta
    # yacreader
    contrast
    # font-manager # (webkitgtk)
    # gcolor3
    # wl-color-picker

    warp
    remmina # (webkitgtk)
    gnome-decoder
    localsend
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
    # librum
    notes
    # endeavour
    # ghostwriter # (qtwebengine)
    # textpieces
    meld

    # HARDWARE TEST
    amdgpu_top
    nvtopPackages.amd
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
    # squirreldisk

    # libinput
    wallutils # lsmon getdpi wayinfo
    wayland-utils
    # wdisplays # wlr

    (writeScriptBin "nsearch" ''nix search nixpkgs "$@"'')
  ];

  services = {
    # disable on wm
    # easyeffects.enable = !config.services.greetd.enable;
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

  ###############################################
  ##  Desktop Environment
  ###############################################
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
      "icons/default/index.theme".text = ''
        [icon theme]
        Inherits=Adwaita
      '';
    };

    mimeApps = {
      enable = false;
      defaultApplications = lib.mkMerge [
        {
          "video/*" = "mpv.desktop";
          "audio/mpeg" = "qmmp.desktop";
          "audio/flac" = "qmmp.desktop";
          "audio/x-vorbis+ogg" = "qmmp.desktop";
          "text/html" = "firefox.desktop";
        }
        (lib.mkIf nixosConfig.services.xserver.desktopManager.gnome.enable {
          "image/*" = "org.gnome.Loupe.desktop";
          "text/plain" = "org.gnome.TextEditor.desktop";
          "application/pdf" = "org.gnome.Evince.desktop";
        })
        (lib.mkIf nixosConfig.services.desktopManager.plasma6.enable {
          "image/*" = "org.kde.gwenview.desktop";
          "text/plain" = "org.kde.kwrite.desktop";
          "application/pdf" = "org.kde.okular.desktop";
        })
      ];
    };

    # Cursor Theme
    # home.pointerCursor = {
    #   name = "Vanilla-DMZ-AA";
    #   package = pkgs.vanilla-dmz;
    #   size = 128;
    #   # name = "Bibata-Modern-Classic";
    #   # package = pkgs.bibata-cursors;
    #   # size = 128;
    # };

    # desktopEntries = {
    #   spotify = {
    #     name = "Spotify";
    #     genericName = "Music Player";
    #     icon = "spotify-client";
    #     exec = "env NIXOS_OZONE_WL= spotify %U --force-device-scale-factor=2";
    #     terminal = false;
    #     categories = ["Application" "Music"];
    #   };
    # };
  };
}
