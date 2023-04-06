/*

# check hardwave virtual supports
LC_ALL=C lscpu | grep Virtualization
dmesg | grep IOMMU

# fix network `default` inactive
sudo virsh net-start default
sudo virsh net-autostart default

Guest:
spice-vdagent  # for clipboard share

# share file
sudo mkdir /mnt/vfs_share
sudo chown iab /mnt/vfs_share
mkdir share #guest
sudo mount -t 9p -o trans=virtio share ~/share #guest
https://www.reddit.com/r/NixOS/comments/11j9qf7/virtio_fs_with_virtmanager/

qemu-system-x86_64 -enable-kvm -m 8192 -cdrom result/iso
*/
{
  config,
  pkgs,
  lib,
  ...
}: {
  options.programs.my-virt = {
    enable =
      lib.mkEnableOption (lib.mdDoc ''
        my virt customize.
      '')
      // {default = true;};
  };

  config = lib.mkIf config.programs.my-virt.enable {
    # services.my-flatpak.enable = true;

    # programs.adb.enable = true;

    # programs.steam.enable = true;

    # programs.java.enable = true;

    programs.nix-ld.enable = true;

    environment.systemPackages = with pkgs; [
      virt-manager
      libguestfs
      bridge-utils
      nix-alien # Run binaries
      (appimage-run.override {
        extraPkgs = pkgs: with pkgs; [libthai];
      })
      # scrcpy # android
      # distrobox
      # bottles # wine manager
      # yuzu
      # gnome.gnome-boxes
      # steam-run
    ];

    virtualisation = {
      spiceUSBRedirection.enable = true; # USB passthrough
      libvirtd = {
        enable = true;
        # allowedBridges = ["br0"];
        qemu = {
          # runAsRoot = false;
          ovmf.enable = true; # UEFI
          # https://adamsimpson.net/writing/windows-11-as-kvm-guest
          package = pkgs.qemu_kvm; # emulate only host architectures
          # swtpm.enable = true;   # emulated TPM
          # ovmf.packages = [
          #   (pkgs.OVMFFull.override
          #     {
          #       secureBoot = true;
          #       tpmSupport = true;
          #     })
          # ];
        };
      };

      # virtualbox = {
      #   host.enable = true;
      #   # host.enableExtensionPack = true;
      # };

      # lxd = {
      #   enable = true;
      # }

      # docker = {
      #   enable = true;
      #   autoPrune.enable = true;
      #   enableOnBoot = true;
      # };

      # podman = {
      #   enable = true;
      #   # Create a `docker` alias for podman, to use it as a drop-in replacement
      #   dockerCompat = true;
      # };

      # containers = {
      #   enable = true;
      #   registries.search = [
      #     "docker.io"
      #     "quay.io"
      #     "registry.opensuse.org"
      #   ];
      # };

      # waydroid.enable = true;
    };

    # Cross compile
    # nix build .#legacyPackages.x86_64-linux.pkgsCross.aarch64-multiplatform.hello
    # boot.binfmt.emulatedSystems = [
    #   "aarch64-linux" # nix build .#legacyPackages.aarch64-linux.hello
    # ];

    # boot.kernelParams =
    #   (lib.optionals config.hardware.cpu.intel.updateMicrocode [ "intel_iommu=on" "iommu=pt" ]);
  };
}
