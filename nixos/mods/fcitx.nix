{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.mods.fcitx;
in
{
  options.mods.fcitx = {
    enable = lib.mkEnableOption (
      lib.mdDoc ''
        my fcitx5 customize.
      ''
    );
  };

  config = lib.mkIf cfg.enable {
    i18n.inputMethod = {
      enabled = "fcitx5";
      fcitx5.waylandFrontend = true;
      fcitx5.plasma6Support = true;
      fcitx5.addons = with pkgs; [
        fluent-fcitx5
        # fcitx5-rose-pine
        # fcitx5-breeze
        # fcitx5-chinese-addons
        (fcitx5-rime.override { rimeDataPkgs = [ pkgs.rime-ice ]; })
      ];
    };
  };
}
