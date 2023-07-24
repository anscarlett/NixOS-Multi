{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./disko.nix
    ./hardware-configuration.nix
  ];

  # disko
  _module.args.disks = ["/dev/vda"];

  # systemd-boot
  boot.loader = {
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/efi";
    systemd-boot.enable = true;
  };

  # kernel: latest / zen / lqx / xanmod_latest
  # boot.kernelPackages = pkgs.linuxPackages;

  # ssh
  services.openssh = {
    settings.PermitRootLogin = "yes";
  };

  # Clipboard shared for NixOS@Guest
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;
}
