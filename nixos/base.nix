{
  lib,
  pkgs,
  config,
  ...
}: {
  boot = {
    # tmp.useTmpfs = true;
    tmp.cleanOnBoot = !config.boot.tmp.useTmpfs;
    plymouth.enable = true;
    supportedFilesystems = ["ntfs"];

    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
    initrd.systemd.enable = lib.mkDefault true;
    # Silent boot when `initrd.systemd` enable
    kernelParams = lib.optionals config.boot.initrd.systemd.enable ["systemd.show_status=false"];
  };

  zramSwap.enable = lib.mkDefault true;

  services = {
    fwupd.enable = true;
    acpid.enable = true;

    journald.extraConfig = ''
      SystemMaxUse=50M
    '';
  };

  environment.systemPackages = with pkgs; [
    binutils
    git
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

  # zsh@hm need this
  programs.zsh.enable = true;
}
