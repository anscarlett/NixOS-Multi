{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix

    inputs.lanzaboote.nixosModules.lanzaboote # Secure Boot

    inputs.nixos-hardware.nixosModules.common-gpu-amd
    inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
    # inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
    # cpupower frequency-info
    # cat /sys/devices/system/cpu/cpufreq/policy0/scaling_driver
    # ls /sys/devices/system/cpu/cpu0/   :show CPPCCPPC
  ];

  # amdvlk or opengl default
  hardware.amdgpu.amdvlk = true;

  #######################################################################
  ## Kernel
  #######################################################################
  # latest or zen or xanmod_latest
  boot.kernelPackages = pkgs.linuxPackages;

  # boot.kernelParams = ["quite"];

  # https://fedoraproject.org/wiki/Changes/IncreaseVmMaxMapCount
  # boot.kernel.sysctl = {
  #   "vm.max_map_count" = 2147483642;  # default: 1048576
  # };

  # boot.plymouth = {
  #   theme = "double";
  #   themePackages = [pkgs.adi1090x-plymouth-themes];
  # };

  # services.logind = {
  #   lidSwitch = "suspend-then-hibernate";
  #   extraConfig = ''
  #     HandlePowerKey=suspend-then-hibernate
  #     IdleAction=suspend-then-hibernate
  #     IdleActionSec=2m
  #   '';
  # };
  # systemd.sleep.extraConfig = "HibernateDelaySec=1h";

  #######################################################################
  ## Bootloader
  #######################################################################
  /*
  disable Secure-Boot and reset to Setup-Mode
  sudo -i
  sbctl create-keys
  sbctl enroll-keys --microsoft
  */
  boot.lanzaboote = {
    enable = true;
    configurationLimit = 3;
    pkiBundle = "/etc/secureboot";
    # settings = {
    # };
  };

  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/efi"; # default /boot
    };
    systemd-boot = {
      # enable = true;
      configurationLimit = 5; # bootmenu items
      consoleMode = "max";
    };
    grub = {
      # enable = true;
      device = "nodev";
      efiSupport = true;
      gfxmodeEfi = "1024x768";
      default = "1";
      # extraEntriesBeforeNixOS = true;
      extraEntries = ''
        menuentry "Windows" {
         search --file --no-floppy --set=root /EFI/Microsoft/Boot/bootmgfw.efi
         chainloader (''${root})/EFI/Microsoft/Boot/bootmgfw.efi
        }
      '';
      # theme = pkgs.fetchzip {
      # https://github.com/AdisonCavani/distro-grub-themes
      #   url = "https://raw.githubusercontent.com/AdisonCavani/distro-grub-themes/master/themes/freeBSD.tar";
      #   hash = "sha256-oTrh+5g73y/AXSR+MPz6a25KyCKCPLL8mZCDup/ENZc=";
      #   stripRoot=false;
      # };
    };
  };

  #######################################################################
  ## FileSystem
  #######################################################################
  services.btrfs.autoScrub.enable = true;
  fileSystems = {
    "/".options = ["compress=zstd" "noatime"];
    #   "/home".options = [ "compress=zstd" ];
    #   "/nix".options = [ "compress=zstd" "noatime" ];
    #   "/swap".options = [ "noatime" ];
    # "/run/media/iab/Win" = {  # too dangerous
    #   device = "/dev/nvme0n1p3";
    #   fsType = "ntfs-3g";
    #   options = [ # ??
    #     # Lazy mounting
    #     "x-systemd.automount"
    #     "noauto"
    #     # disconnects after 10 minutes (i.e. 600 seconds)
    #     # "x-systemd.idle-timeout=600"
    #   ];
    #   # options = ["rw" "uid=${username}"]; # default was enough
    # };
  };

  # Swapfile
  swapDevices = [
    {
      device = "/var/swapfile";
      size = 1024 * 8;
    }
  ];
  # findmnt -no UUID -T /swap/swapfile
  # sudo filefrag -v /swap/swapfile | awk '$1=="0:" {print substr($4, 1, length($4)-2)}'
  # boot.resumeDevice = "/dev/disk/by-uuid/a0e48512-1e47-409d-9c91-7bbca721dbfc";
  # boot.kernelParams = [ # "mem_sleep_default=deep"
  #                       "resume_offset=42166446" ];
}
