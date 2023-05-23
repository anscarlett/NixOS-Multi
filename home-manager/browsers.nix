{
  pkgs,
  username,
  ...
}: let
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
    profiles.${username} = {
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
      };
    };
  };
}
