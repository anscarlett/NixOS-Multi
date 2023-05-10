{
  lib,
  pkgs,
  config,
  username,
  modulesPath,
  ...
}: {
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-graphical-base.nix"
    ../../nixos/gnome.nix
  ];

  environment.systemPackages = with pkgs; [
  ];

  programs.partition-manager.enable = true;

  # faster but bigger size
  isoImage.squashfsCompression = "gzip -Xcompression-level 1";

  # Clipboard shared for NixOS@Guest
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;

  boot = {
    # kernelParams = ["quite"];
    supportedFilesystems = lib.mkForce ["btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs"];
    initrd.systemd.enable = false;
  };

  services.xserver = {
    xkbOptions = "ctrl:swapcaps"; # Xorg Layout
  };

  # services.xserver.displayManager.autoLogin.enable = lib.mkForce false;

  # password: livecd
  users.users.${username}.hashedPassword =
    lib.mkForce
    "$6$UYQgz/DrPc.MozSy$iU1FVbSqDfSH9ppUo66RPMvX6qBR6yHJfdS/wgFxSBb5Evgf0VPLgXbhGEgoYWbEWkFyms3ahTmQqTCOy.4o/.";
}
