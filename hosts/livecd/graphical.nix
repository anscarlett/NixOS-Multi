{
  inputs,
  self,
  pkgs,
  lib,
  config,
  username,
  modulesPath,
  ...
}: {
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-graphical-base.nix"
    self.nixosModules.gnome
  ];

  mods.virt.enable = false;

  environment.systemPackages = with pkgs; [
  ];

  boot = {
    initrd.systemd.enable = false;
    supportedFilesystems = lib.mkForce ["btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs"];
    # kernelParams = ["quite"];
  };

  services.xserver = {
    xkbOptions = "ctrl:swapcaps"; # Xorg Layout
  };

  # Clipboard shared for NixOS@Guest
  # services.qemuGuest.enable = true;
  # services.spice-vdagentd.enable = true;

  # services.xserver.displayManager.autoLogin.enable = lib.mkForce false;

  # password: livecd
  users.users.${username}.password = lib.mkForce "livecd";

  # faster but bigger size
  # isoImage.squashfsCompression = "gzip -Xcompression-level 1";
}