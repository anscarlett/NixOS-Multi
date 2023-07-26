{
  inputs,
  self,
  pkgs,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    ./disko.nix
    (modulesPath + "/profiles/qemu-guest.nix")
    self.nixosModules.gnome
    # self.nixosModules.kde
  ];

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

  boot.kernelModules = ["kvm-amd"];

  # systemd-boot
  boot.loader = {
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/efi";
    systemd-boot.enable = true;
  };

  # ssh
  services.openssh = {
    settings.PermitRootLogin = "yes";
  };

  # Clipboard shared for NixOS@Guest
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;
}
