{ lib, ... }:
{
  # ../../home-manager/browsers.nix
  programs.firefox = {
    enable = lib.mkDefault false;
    languagePacks = [ "zh-CN" ];
  };
}
