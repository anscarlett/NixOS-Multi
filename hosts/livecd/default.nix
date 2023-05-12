{
  lib,
  pkgs,
  inputs,
  config,
  username,
  modulesPath,
  ...
}: {
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-graphical-base.nix"
    ../../nixos/desktop/gnome.nix
  ];

  programs.my-virt.enable = false;

  environment.systemPackages = with pkgs; [
  ];

  boot = {
    # kernelParams = ["quite"];
    supportedFilesystems = lib.mkForce ["btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs"];
    initrd.systemd.enable = false;
  };

  services.xserver = {
    xkbOptions = "ctrl:swapcaps"; # Xorg Layout
  };

  # Clipboard shared for NixOS@Guest
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;

  # services.xserver.displayManager.autoLogin.enable = lib.mkForce false;

  # password: livecd
  users.users.${username}.password = lib.mkForce "livecd";

  # faster but bigger size
  isoImage.squashfsCompression = "gzip -Xcompression-level 1";
}
