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
  users.users.${username}.initialPassword = "livecd";

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # faster but bigger size
  isoImage.squashfsCompression = "gzip -Xcompression-level 1";
}
