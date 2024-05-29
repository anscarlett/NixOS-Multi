{
  inputs,
  self,
  pkgs,
  lib,
  config,
  username,
  modulesPath,
  ...
}:
{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-graphical-base.nix"

    self.nixosModules.gnome
    # self.nixosModules.kde
    # self.nixosModules.sway
    # self.nixosModules.hyprland
  ];

  # fast but lowest compression level
  isoImage.squashfsCompression = "gzip -Xcompression-level 1";

  mods.virt.enable = false;

  environment.systemPackages = with pkgs; [ dippi ];

  boot = {
    initrd.systemd.enable = false;
    kernelPackages = pkgs.linuxPackages_latest;
  };

  services.xserver = {
    xkbOptions = "ctrl:swapcaps"; # Xorg Layout
  };

  # password: livecd
  users.users.${username}.password = lib.mkForce "livecd";
}
