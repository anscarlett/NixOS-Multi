{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.mods.steam;
in
{
  options.mods.steam = {
    enable = lib.mkEnableOption ''
      my steam mode.
    '';
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ mangohud ];

    programs.gamemode.enable = true;

    programs.steam = {
      enable = true;
      # fix steam tofu
      package = pkgs.steam.override { extraPkgs = pkgs: [ pkgs.noto-fonts-cjk-sans ]; };
      gamescopeSession.enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
  };
}
