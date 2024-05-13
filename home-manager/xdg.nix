{
  lib,
  config,
  nixosConfig,
  ...
}:
{
  home.sessionPath = [
    "${../dotfiles/bin}"
    "${config.home.homeDirectory}/.local/bin"
    "${config.home.homeDirectory}/.emacs.d/bin"
  ];

  home.sessionVariables = {
    VISUAL = "micro";
    EDITOR = "emacs";
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
