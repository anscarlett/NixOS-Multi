{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    # Overlays
    harmonyos-sans
    misans
    # zee
    # frog
    # clash-verge
    # app-icon-preview
    # newaita-icon-theme
    # go-translation
    # dippi

    gitg
    v2ray
    qv2ray
    # clash
    # nur.repos.linyinfeng.clash-for-windows
    foot
    alacritty

    # (pkgs.google-chrome.override {
    #   commandLineArgs = "--ozone-platform-hint=auto --enable-features=VaapiVideoDecoder --use-gl=egl";
    # })
    # microsoft-edge

    qbittorrent
    mpv
    # vlc
    ffmpeg
    spotify
    mousai # 听歌识曲
    blanket
    shortwave
    # easyeffects
    # shutter
    # tdesktop
    fractal
    meld
    deja-dup
    # rclone
    # rclone-browser
    # vorta
    yacreader
    # qalculate-gtk # scientific calculator
    # bottles # wine manager
    # yuzu

    # OFFICE
    # libreoffice-fresh
    # rnote # handwritten note

    # HARDWARE TEST
    efibootmgr
    # efitools
    inxi
    lm_sensors
    lshw
    hwinfo
    cpufetch
    usbutils
    dmidecode
    glxinfo
    libva-utils #vainfo
    vulkan-tools
    cpufrequtils
    pciutils
    edid-decode
    # libinput
    wallutils # lsmon getdpi wayinfo
    wayland-utils
    # wdisplays # wlr
  ];

  xdg.configFile = {
      "mpv".source = ../dotfiles/mpv;
      "foot/foot.ini".source = ../dotfiles/foot.ini;
      "wezterm/wezterm.lua".source = ../dotfiles/wezterm.lua;
      "alacritty/alacritty.yml".source = ../dotfiles/alacritty.yml;
  };

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-wayland;
  };

  # not work?
  programs.chromium = {
    enable = false;
    package = pkgs.google-chrome;
    commandLineArgs = [
      "--ozone-platform=wayland"
      "--enable-features=VaapiVideoDecoder"
    ];
  };
}
