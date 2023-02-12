{ config, pkgs, lib, inputs, username, ... }: {

  imports = [
    "${inputs.nixpkgs}/nixos/modules/virtualisation/qemu-vm.nix"
    # "${inputs.pkgsReview}/nixos/modules/services/desktops/pipewire/pipewire.nix"
    # ../../modules/gnome.nix
    # ../../modules/kde.nix
    # ../../modules/wm-sway.nix
  ];

  disabledModules = [
    # "services/desktops/pipewire/pipewire.nix"
  ];

  environment.systemPackages = with pkgs; [
    clash-verge

    git
    firefox
    goodvibes
    gnomeExtensions.appindicator
  ];

  environment.variables = { };

  services.xserver = {
    enable = true;
    desktopManager = {
      plasma5.enable = true;
      # gnome.enable = true;
      # xfce.enable = true;
      # cinnamon.enable = true;
      # pantheon.enable = true;
      # enlightenment.enable = true;
      # mate.enable = true;
      # lxqt.enable = true;
    };
    displayManager.autoLogin.user = lib.mkForce "${username}";
    xkbOptions = "ctrl:swapcaps"; # Xorg Layout
  };

  # boot.initrd.kernelModules = ["virtio" "virtio_pci" "virtio_net" "virtio_rng" "virtio_blk" "virtio_console"];

  # latest or zen or xanmod_latest
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Clipboard shared for NixOS@Guest
  services.spice-vdagentd.enable = true;
  services.qemuGuest.enable = true;

  virtualisation = {
    memorySize = 1024 * 3;
    diskSize = 1024 * 8;
    cores = 4;
    msize = 104857600; # 100M
    qemu = {
      options = [
        # Sounds
        "-audiodev pa,id=snd0"
        "-device ich9-intel-hda"
        "-device hda-duplex,audiodev=snd0"
        # Graphical for sway
        # "-vga qxl"
      ];
    };
  };

  users.users.root = {
    password = "root";
  };

  # Password: test
  users.users.${username}.hashedPassword = lib.mkForce "$6$HFoXsNJNYZ.lVv0r$vxau6GLUcGMmPctb135ZFYzRO7p0Y0JXDeqSASudCbSSa917.7I4Vi1A/AOjWAWkT2DguOB0VMf0.HW4cy5zp0";
}
