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

  config = let
    cfg = config.programs.my-fcitx;
  in
    lib.mkIf cfg.enable {
      i18n.inputMethod = lib.mkIf cfg.enable {
        enabled = "fcitx5";
        fcitx5.enableRimeData = true;
        fcitx5.addons = with pkgs; [
          fcitx5-rime
          fcitx5-breeze
          rime-easy-en
          rime-aurora-pinyin
          # fcitx5-chinese-addons
        ];
      };
    };
}
