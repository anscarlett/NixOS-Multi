{
  pkgs,
  ...
}: {
  services = {
    xserver = {
      enable = true;
      excludePackages = [pkgs.xterm];
      # displayManager.gdm.enable = true;
      desktopManager.deepin.enable = true;
    };
  };

  # environment.deepin.excludePackages = with pkgs.deepin; [
  # ];

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
