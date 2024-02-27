{
  config,
  lib,
  pkgs,
  username,
  ...
}:
let
  cfg = config.mods.doas;
in
{
  options.mods.doas = {
    enable = lib.mkEnableOption (
      lib.mdDoc ''
        my doas customize.
      ''
    );
  };

  config = lib.mkIf cfg.enable {
    security.sudo.enable = false;

    security.doas = {
      enable = true;
      # wheelNeedsPassword = false;
      extraRules = [
        {
          users = [ "${username}" ];
          noPass = true;
          keepEnv = true;
        }
      ];
    };

    environment.systemPackages = [
      pkgs.doas-sudo-shim
    ];

    environment.shellAliases = {
      sudoedit = "doas micro";
    };
  };
}
