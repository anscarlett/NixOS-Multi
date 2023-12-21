{
  pkgs,
  lib,
  inputs,
  self,
  username,
  ...
}: {
  imports = [
    "${inputs.nixpkgs}/nixos/modules/virtualisation/qemu-vm.nix"
    # "${inputs.pkgsReview}/nixos/modules/services/desktops/pipewire/pipewire.nix"
    self.nixosModules.gnome
    # self.nixosModules.kde
  ];

  disabledModules = [
    # "services/desktops/pipewire/pipewire.nix"
  ];

  mods.virt.enable = false;
  # mods.fcitx.enable = true;

  environment.systemPackages = with pkgs; [
    git
    firefox
    notes
    gnomeExtensions.appindicator
  ];

  environment.variables = {};

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

  # boot.initrd.kernelModules = ["virtio" "virtio_pci" "virtio_net" "virtio_rng" "virtio_blk" "virtio_console"];

  # Clipboard shared for NixOS@Guest
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;

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

  users.users.root.password = "root";
  users.users.${username}.password = lib.mkForce "test";

  home-manager.users.${username} = {
  };
}
