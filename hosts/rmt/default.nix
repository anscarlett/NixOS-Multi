{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./disko.nix
    ./hardware-configuration.nix
  ];

  _module.args.disks = ["/dev/vda"];

  boot.loader = {
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/efi";
    systemd-boot.enable = true;
  };

  # latest / zen / lqx / xanmod_latest
  # boot.kernelPackages = pkgs.linuxPackages;

  services.openssh = {
    settings.PermitRootLogin = true;
  };

  # Clipboard shared for NixOS@Guest
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;
}
