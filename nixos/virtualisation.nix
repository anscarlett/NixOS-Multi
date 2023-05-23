/*
## fix network `default` inactive
sudo virsh net-start default
sudo virsh net-autostart default

## for clipboard share
spice-vdagent (Guest)

## for folders share
Memory —— enable the shared memory
Add filesystem: virtiofs ~/Downloads shared

edit xml (nixos bug):
<binary path="/run/current-system/sw/bin/virtiofsd"/>

mkdir shared (Guest)
sudo mount -t virtiofs shared /home/iab/shared (Guest)

## Windows Guest
add tpm: tpm-crb、emulator、2.0
https://www.spice-space.org/download.html  # spice-guest-tools

## qemu iso emulator
qemu-system-x86_64 -enable-kvm -m 8192 -cdrom result/iso
*/
{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mods.virt;
in {
  options.mods.virt.enable =
    lib.mkEnableOption (lib.mdDoc ''
      my virt customize.
    '')
    // {default = true;};

  config = lib.mkIf cfg.enable {
    # mods.flatpak.enable = true;

    # programs.adb.enable = true;

    # programs.steam.enable = true;

    # programs.java.enable = true;

    programs.nix-ld.enable = true;

    environment.systemPackages = with pkgs; [
      virt-manager
      virtiofsd
      bridge-utils # brctl: network bridge
      # win-virtio # needs ?
      (appimage-run.override {
        extraPkgs = pkgs:
          with pkgs; [
            libthai
            # libsecret
          ];
      })
      # scrcpy # android
      # distrobox
      # bottles # wine manager
      # gnome.gnome-boxes
      # steam-run
      # yuzu
    ];

    virtualisation = {
      spiceUSBRedirection.enable = true; # USB passthrough
      libvirtd = {
        enable = true;
        # allowedBridges = ["br0"];
        qemu = {
          # runAsRoot = false;
          package = pkgs.qemu_kvm; # emulate only host architectures
          # swtpm.enable = true; # emulated TPM
          ovmf = {
            enable = true; # UEFI
            # packages = [
            #   (pkgs.OVMFFull.override
            #     {
            #       secureBoot = true;
            #       tpmSupport = true;
            #     })
            # ];
          };
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
