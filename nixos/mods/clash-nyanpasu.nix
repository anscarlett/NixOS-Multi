{ config, lib, pkgs, ... }:

{
  options.programs.clash-nyanpasu = {
    enable = lib.mkEnableOption (lib.mdDoc "Clash Nyanpasu");
    autoStart = lib.mkEnableOption (lib.mdDoc "Clash Nyanpasu auto launch");
    tunMode = lib.mkEnableOption (lib.mdDoc "Clash Nyanpasu TUN mode");
  };

  config =
    let
      cfg = config.programs.clash-nyanpasu;
    in
    lib.mkIf cfg.enable {

      environment.systemPackages = [
        pkgs.clash-nyanpasu
        (lib.mkIf cfg.autoStart (pkgs.makeAutostartItem {
          name = "clash-nyanpasu";
          package = pkgs.clash-nyanpasu;
        }))
      ];

      security.wrappers.clash-nyanpasu = lib.mkIf cfg.tunMode {
        owner = "root";
        group = "root";
        capabilities = "cap_net_bind_service,cap_net_admin=+ep";
        source = "${lib.getExe pkgs.clash-nyanpasu}";
      };
    };

  meta.maintainers = with lib.maintainers; [ zendo ];
}
