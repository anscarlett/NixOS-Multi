{
  inputs,
  self,
  pkgs,
  ...
}: {
  imports = [
    ./disko.nix
    # ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.common-gpu-intel
    inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd

    self.nixosModules.gnome
  ];

  #######################################################################
  ## Kernel
  #######################################################################
  # latest / zen / lqx / xanmod_latest
  # boot.kernelPackages = pkgs.linuxPackages;

  boot.kernelModules = ["kvm-intel"];

  boot.initrd.availableKernelModules = [
    # "nvme"
    "ahci" # SATA
    "xhci_pci" # USB3.0
    "ehci_pci" # USB2.0
    "usb_storage"
    "sd_mod"
    ## virt
    # "virtio_pci"
    # "sr_mod"
    # "virtio_blk"
  ];

  hardware.cpu.intel.updateMicrocode = true;

  hardware.enableRedistributableFirmware = true;

  #######################################################################
  ## Bootloader
  #######################################################################
  # boot.loader = {
  #   efi.canTouchEfiVariables = true;
  #   efi.efiSysMountPoint = "/boot/efi"; # default /boot
  #   systemd-boot.enable = true;
  # };

  boot.loader = {
    # efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/efi"; # default /boot
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
