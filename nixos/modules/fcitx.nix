{
  lib,
  pkgs,
  config,
  ...
}: {
  options.programs.my-fcitx = {
    enable = lib.mkEnableOption (lib.mdDoc ''
      my fcitx5 customize.
    '');
  };

  config = lib.mkIf config.programs.my-fcitx.enable {
    i18n.inputMethod = {
      enabled = "fcitx5";
      fcitx5.addons = with pkgs; [
        fcitx5-breeze
        # fcitx5-chinese-addons
        (fcitx5-rime.override {
          rimeDataPkgs = with pkgs; [
            rime-data
            rime-ice
          ];
        })
      ];
    };
  };
}
