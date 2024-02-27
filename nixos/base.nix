{
  lib,
  pkgs,
  config,
  ...
}:
{
  boot = {
    plymouth.enable = true;
    # tmp.useTmpfs = true;
    tmp.cleanOnBoot = !config.boot.tmp.useTmpfs;
    initrd.systemd.enable = lib.mkDefault true;
    # Silent boot when `initrd.systemd` enable
    kernelParams = lib.optionals config.boot.initrd.systemd.enable [ "systemd.show_status=false" ];
  };

  services = {
    fwupd.enable = true;
    acpid.enable = true;
    zram-generator = {
      enable = lib.mkDefault true;
      settings.zram0 = {
        compression-algorithm = "zstd";
        zram-size = "ram / 2";
      };
    };

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

  # make `xdg-open` works inside FHS envs
  xdg.portal.xdgOpenUsePortal = true;

  programs.command-not-found.enable = false;
  documentation.enable = false;
  time.timeZone = "Asia/Shanghai";
  system.stateVersion = "24.05";
}
