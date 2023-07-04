{
  lib,
  config,
  username,
  ...
}: let
  cfg = config.mods.doas;
in {
  options.mods.doas = {
    enable = lib.mkEnableOption (lib.mdDoc ''
      my doas customize.
    '');
  };

  config = lib.mkIf cfg.enable {
    security.sudo.enable = false;
    security.doas.enable = true;

    # security.doas.wheelNeedsPassword = false;
    security.doas.extraRules = [
      {
        users = ["${username}"];
        noPass = true;
        keepEnv = true;
      }
    ];

    environment.shellAliases = {
      sudo = "doas";
      sudoedit = "doas micro";
    };
  };
}