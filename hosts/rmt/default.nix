{
  inputs,
  self,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    ./disko.nix
    (modulesPath + "/profiles/qemu-guest.nix")
    self.nixosModules.gnome
    # self.nixosModules.kde
  ];

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
