{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    (google-chrome.override {
      commandLineArgs = [
        "--use-gl=egl"
        "--gtk-version=4"
        "--enable-features=VaapiVideoDecoder,TouchpadOverscrollHistoryNavigation"
      ];
    })
    # (vivaldi.override {
    #   proprietaryCodecs = true;
    #   enableWidevine = true; # drm
    # })
    # (opera.override { proprietaryCodecs = true; })
    # microsoft-edge-beta
  ];

  programs.chromium = {
    # enable = true;
    commandLineArgs = [
      "--use-gl=egl"
      "--gtk-version=4"
      "--enable-features=VaapiVideoDecoder,TouchpadOverscrollHistoryNavigation"
    ];
    extensions = [
      "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
      "fihnjjcciajhdojfnbdddfaoknhalnja" # I don't care about cookies
      "hbhaimhpaplfkjfncbkdnadppobbopbi" # SimpleProxy
      "mjidkpedjlfnanainpdfnedkdlacidla" # CLEAN crxMouse Gestures
      "hmbmmdjlcdediglgfcdkhinjdelkiock" # Font Rendering Enhancer
      "aapbdbdomjkkjkaonfhkkikfgjllcleb" # Google Translate
      "jinjaccalgkegednnccohejagnlnfdag" # Violentmonkey
      "dbepggeogbaibhgnhhndojpepiihcmeb" # Vimium
    ];
  };

  programs.firefox = {
    # enable = true;
    # package = pkgs.firefox-bin;
    # profiles."default".extraConfig = ''
    #   # drm
    #   "media.eme.enabled" = true;

    #   # Hide bookmarks
    #   "browser.toolbars.bookmarks.visibility" = "never";

    #   # Dont show warning when accessing about:config
    #   "browser.aboutConfig.showWarning" = false;
    # '';
  };
}
