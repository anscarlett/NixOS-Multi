{
  inputs,
  self,
  pkgs,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    ./disko-btrfs.nix
    # ./disko-bcachefs.nix
    (modulesPath + "/profiles/qemu-guest.nix")
    self.nixosModules.gnome
    # self.nixosModules.kde
  ];

  # Desktop Envirment
  services.xserver = {
    enable = true;
    desktopManager = {
      # gnome.enable = true;
      # plasma5.enable = true;
      # xfce.enable = true;
      # budgie.enable = true;
      # deepin.enable = true;
      # cinnamon.enable = true;
      # pantheon.enable = true;
      # enlightenment.enable = true;
      # mate.enable = true;
      # lxqt.enable = true;
    };
    # displayManager.autoLogin.user = lib.mkForce "guest";
    xkbOptions = "ctrl:swapcaps"; # Xorg Layout
  };

  # Kernel
  boot.kernelModules = ["kvm-amd"];

  # bcachefs
  # boot.supportedFilesystems = ["bcachefs"];

  # Systemd-boot
  boot.loader = {
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/efi";
    systemd-boot.enable = true;
  };

  # SSH
  services.openssh = {
    settings.PermitRootLogin = "yes";
  };

  # Clipboard shared for NixOS@Guest
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;
}
