{
  inputs,
  self,
  pkgs,
  ...
}: {
  imports = [
    ./disko.nix
    inputs.nixos-hardware.nixosModules.common-gpu-intel
    inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
    self.nixosModules.gnome
  ];

  boot.kernelModules = ["kvm-intel"];

  # boot.initrd.availableKernelModules = [
  #   # "nvme"
  #   "ahci" # SATA
  #   "xhci_pci" # USB3.0
  #   "ehci_pci" # USB2.0
  #   "usb_storage"
  #   "sd_mod"
  # ];

  hardware.cpu.intel.updateMicrocode = true;

  hardware.enableRedistributableFirmware = true;

  #######################################################################
  ## Bootloader
  #######################################################################
  boot.loader = {
    efi.efiSysMountPoint = "/efi";
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      # Because this machine's efivars can't touch
      # It just move grubx64.efi -> Boot/bootx64.efi
      efiInstallAsRemovable = true;
      # extraEntries = ''
      #   menuentry "Arch Linux" {
      #    search --file --no-floppy --set=root /EFI/arch/grubx64.efi
      #    chainloader (''${root})/EFI/arch/grubx64.efi
      #   }
      # '';
    };
  };

  #######################################################################
  ## FileSystem
  #######################################################################
  services.btrfs.autoScrub.enable = true;

  # Swapfile
  swapDevices = [
    {
      device = "/var/swapfile";
      size = 1024 * 8;
    }
  ];
}
