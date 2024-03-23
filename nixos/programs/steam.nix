{ pkgs, ... }:
{
  programs.steam = {
    # enable = true;
    # fix steam tofu
    package = pkgs.steam.override { extraPkgs = pkgs: [ pkgs.noto-fonts-cjk-sans ]; };
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
}
