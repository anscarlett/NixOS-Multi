# https://github.com/nix-community/srvos/blob/main/nixos/server/default.nix
{ lib, pkgs, ... }:
{

  # No need for fonts on a server
  fonts.fontconfig.enable = lib.mkDefault false;

  # Make sure firewall is enabled
  networking.firewall.enable = true;

  # Enable SSH everywhere
  services.openssh.enable = true;

  # No need for sound on a server
  sound.enable = false;

  # UTC everywhere!
  time.timeZone = lib.mkDefault "UTC";

  # No mutable users by default
  users.mutableUsers = false;
}
