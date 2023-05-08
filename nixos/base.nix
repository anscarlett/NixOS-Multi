{
  lib,
  pkgs,
  config,
  ...
}: {
  zramSwap.enable = true;

  boot = {
    # tmp.useTmpfs = true;
    # manual cleaning /tmp, if not using tmpfs
    tmp.cleanOnBoot = !config.boot.tmp.useTmpfs;
    plymouth.enable = true;
    supportedFilesystems = ["ntfs"];

    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
    # Silent boot on `initrd.systemd`
    kernelParams = ["systemd.show_status=false"];
    initrd.systemd.enable = true;
  };

  services = {
    fwupd.enable = true;
    acpid.enable = true;

    journald.extraConfig = ''
      SystemMaxUse=50M
    '';
  };

  environment.systemPackages = with pkgs; [
    binutils
    tree
    file
    wget
    curl
    parted
    gptfdisk
    micro
    sniffglue
    nix-bash-completions
    sbctl
    efibootmgr
    # efitools
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # zsh@hm needs this
  programs.zsh.enable = true;

  # broken in flake
  programs.command-not-found.enable = false;

  # slow down in nixos-rebuild
  documentation.enable = false;

  time.timeZone = "Asia/Shanghai";

  system.stateVersion = "22.05";
}
