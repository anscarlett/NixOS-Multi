{
  lib,
  pkgs,
  config,
  ...
}: {
  options.programs.fcitxCustomize = {
    enable = lib.mkEnableOption (lib.mdDoc ''
      fcitx5 customize.
    '');
  };

  config = let
    cfg = config.programs.fcitxCustomize;
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
