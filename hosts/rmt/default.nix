{
  inputs,
  self,
  pkgs,
  lib,
  modulesPath,
  ...
}:
{
  imports = [
    # ./disko-btrfs.nix
    ./disko-bcachefs.nix
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  mods.gnome.enable = true;

  # services.flatpak.enable = true;

  environment.systemPackages = with pkgs; [
    notes

    skim
    ripgrep
    duf
    gdu
  ];

  # services.desktopManager.plasma6.enable = true;

  # Desktop Envirment
  services.xserver = {
    enable = true;
    desktopManager = {
      # gnome.enable = true;
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
  boot.kernelModules = [ "kvm-amd" ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

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
