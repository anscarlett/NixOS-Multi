{pkgs, ...}: let
  chromeEnv = [
    "--ignore-gpu-blocklist"
    "--enable-gpu-rasterization"
    "--enable-zero-copy"
    "--gtk-version=4"
    "--enable-features=TouchpadOverscrollHistoryNavigation"
  ];
in {
  home.packages = with pkgs; [
    # https://wiki.archlinux.org/title/Chromium
    # (google-chrome.override {
    #   commandLineArgs = chromeEnv;
    # })
    # (vivaldi.override {
    #   proprietaryCodecs = true;
    #   enableWidevine = true; # drm
    # })
    # (opera.override { proprietaryCodecs = true; })
    # microsoft-edge-beta
  ];

  programs.chromium = {
    # enable = true;
    # package = pkgs.chromiumDev;
    commandLineArgs = chromeEnv;
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
    enable = true;
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
