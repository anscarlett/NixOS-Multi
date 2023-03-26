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

    # Silent boot at initrd.systemd
    kernelParams = ["systemd.show_status=false"];
    initrd.systemd.enable = true;
  };

  hardware.enableRedistributableFirmware = true;

  zramSwap.enable = true;

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
    parted
    gptfdisk
    sniffglue
    nix-bash-completions
    sbctl
    efibootmgr
    # efitools
  ];

  # environment.sessionVariables = {
  # };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.zsh.enable = true;

  programs.command-not-found.enable = false;

  documentation.enable = false;

  time.timeZone = "Asia/Shanghai";

  system.stateVersion = "22.05";
}
