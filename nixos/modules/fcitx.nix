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
      fcitx5.enableRimeData = true;
      # rime.packages = [ pkgs.rime-ice ];
      fcitx5.addons = with pkgs; [
        fcitx5-rime
        fcitx5-breeze
        rime-ice
        # fcitx5-chinese-addons
      ];
    };
  };
}
