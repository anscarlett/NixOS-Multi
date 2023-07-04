{
  pkgs,
  ...
}: let
  chromeEnv = [
    "--enable-features=VaapiVideoDecodeLinuxGL"
    "--gtk-version=4" # broken! 主题改经典 fix
    # https://bugs.chromium.org/p/chromium/issues/detail?id=1356014
    "--disable-features=WaylandFractionalScaleV1"
    "--enable-features=TouchpadOverscrollHistoryNavigation"
  ];
in {
  home.packages = with pkgs; [
    (google-chrome.override {
      commandLineArgs = chromeEnv;
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
    profiles.default = {
      settings = {
        "browser.aboutwelcome.enabled" = false;
        # 双击关闭标签
        "browser.tabs.closeTabByDblclick" = true;
        # 关闭标签后选附近标签而不是原始
        "browser.tabs.selectOwnerOnClose" = false;
        # 关闭最后一个标签不退出界面
        "browser.tabs.closeWindowWithLastTab" = false;
        # disable Firefox View button on tab
        "browser.tabs.firefox-view" = false;
        # DRM
        "media.eme.enabled" = true;
        # Always show bookmarks
        "browser.toolbars.bookmarks.visibility" = "always";
        # Dont show warning when accessing about:config
        "browser.aboutConfig.showWarning" = false;
        # disable annoyinh Ctrl+Q shortcut
        "browser.quitShortcut.disabled" = true;
        # 开启极速渲染
        "gfx.webrender.all" = true;
        # enable hw video acceleration, if supported
        "media.ffmpeg.vaapi.enabled" = true;
        # https://pandasauce.org/get-fonts-done/
        # "gfx.text.subpixel-position.force-enabled" = true;
        # "gfx.webrender.quality.force-subpixel-aa-where-possible" = true;
        # Enable some helpful features in urlbar
        "browser.urlbar.suggest.calculator" = true;
        "browser.urlbar.unitConversion.enabled" = true;
      };
    };
  };
}
