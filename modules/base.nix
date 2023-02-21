{
  config,
  pkgs,
  ...
}: {
  boot = {
    # tmpOnTmpfs = true;
    cleanTmpDir = true;
    plymouth.enable = true;
    supportedFilesystems = ["ntfs"];

    # Silent boot on initrd.systemd
    kernelParams = ["systemd.show_status=false"];
    initrd.systemd.enable = true;
  };

  zramSwap.enable = true;

  services = {
    fwupd.enable = true;
    acpid.enable = true;

    journald.extraConfig = ''
      SystemMaxUse=500M
    '';
  };

  environment.systemPackages = with pkgs; [
    binutils
    tree
    file
    wget
    parted
    gptfdisk
    sniffglue
    nix-bash-completions
    sbctl
    efibootmgr
    # efitools
  ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # Electron wayland support
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.command-not-found.enable = false;

  documentation.enable = false;

  time.timeZone = "Asia/Shanghai";

  system.stateVersion = "22.05";
}
