{
  inputs,
  self,
  config,
  pkgs,
  lib,
  modulesPath,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix

    # Secure Boot
    # inputs.lanzaboote.nixosModules.lanzaboote

    # "${modulesPath}/profiles/perlless.nix"

    inputs.nixos-hardware.nixosModules.common-gpu-amd
    # inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
    # inputs.nixos-hardware.nixosModules.lenovo-yoga-7-14ARH7.amdgpu
    # cpupower frequency-info
    # cat /sys/devices/system/cpu/cpufreq/policy0/scaling_driver
    # ls /sys/devices/system/cpu/cpu0/   :show CPPCCPPC

    # "${inputs.nixpkgs-pr}/nixos/modules/config/swap.nix"

    self.nixosModules.gnome
    # self.nixosModules.kde
    # self.nixosModules.sway
    # self.nixosModules.hyprland
  ];

  ###############################################
  ## Mods
  ###############################################
  mods = {
    # steam.enable = true;
  };

  programs = {
    # nix-ld.enable = true;
    firefox.enable = true;
  };

  # disabledModules = ["config/swap.nix"];

  # environment.systemPackages = with pkgs; [
  #   # inputs.nixpkgs-pr.legacyPackages.x86_64-linux.apps
  # ];

  ###############################################
  ## Hardware
  ###############################################

  hardware.amdgpu.amdvlk.enable = true;

  # Optimize SSD
  services.fstrim.enable = lib.mkDefault true;

  ###############################################
  ## Network
  ###############################################
  # mods.daeWithConfig.enable = true;

  # disabledModules = [ "programs/clash-verge.nix" ];
  programs.clash-verge = {
    enable = true;
    tunMode = true;
    autoStart = true;
    package = pkgs.clash-verge-rev;
  };

  # services.v2raya.enable = true;

  ###############################################
  ## Kernel
  ###############################################
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    supportedFilesystems = [ "ntfs" ];

    # plymouth = {
    #   theme = "double";
    #   themePackages = [pkgs.adi1090x-plymouth-themes];
    # };

    # Disabling Laptop's internal keyboard
    # kernelParams = ["i8042.nokbd"];

    # https://fedoraproject.org/wiki/Changes/IncreaseVmMaxMapCount
    # kernel.sysctl = {
    #   "vm.max_map_count" = 2147483642; # default: 1048576
    # };
  };

  # services.logind = {
  #   lidSwitch = "suspend-then-hibernate";
  #   extraConfig = ''
  #     HandlePowerKey=suspend-then-hibernate
  #     IdleAction=suspend-then-hibernate
  #     IdleActionSec=2m
  #   '';
  # };
  # systemd.sleep.extraConfig = "HibernateDelaySec=1h";

  ###############################################
  ## Bootloader
  ###############################################
  /*
    disable Secure-Boot and reset to Setup-Mode
    sudo -i
    sbctl create-keys
    sbctl enroll-keys --microsoft
  */
  # boot.lanzaboote = {
  #   enable = true;
  #   configurationLimit = 3;
  #   pkiBundle = "/etc/secureboot";
  #   # settings = {
  #   # };
  # };

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
      enable = true;
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
        menuentry "Firmware" {
         fwsetup
        }
        menuentry "Shutdown" {
         halt
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

  ###############################################
  ## FileSystem
  ###############################################
  services.btrfs.autoScrub.enable = true;

  fileSystems = {
    "/".options = [
      "compress=zstd"
      "noatime"
    ];
    #   "/home".options = [ "compress=zstd" ];
    #   "/nix".options = [ "compress=zstd" "noatime" ];
    #   "/swap".options = [ "noatime" ];
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
