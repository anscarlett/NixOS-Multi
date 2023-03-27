# nixos-generate -f iso -c ~/nsworld/hosts/livecd/vanilla-iso.nix
{
  lib,
  pkgs,
  config,
  modulesPath,
  ...
}: {
  imports = [
    # "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
    # "${modulesPath}/installer/cd-dvd/installation-cd-graphical-gnome.nix"
    # "${modulesPath}/installer/cd-dvd/installation-cd-graphical-plasma5.nix"
    "${modulesPath}/installer/cd-dvd/installation-cd-graphical-calamares-gnome.nix"
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest; # latest zen xanmod_latest
    supportedFilesystems = lib.mkForce ["btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs"];
  };

  services.xserver = {
    xkbOptions = "ctrl:swapcaps"; # Xorg Layout
  };

  # services.xserver.displayManager.autoLogin.enable = lib.mkForce false;

  hardware.enableAllFirmware = true;

  nixpkgs = {
    config.allowUnfree = true;
    config.allowBroken = true;
  };

  nix.settings = {
    substituters = lib.mkForce [
      "https://mirror.sjtu.edu.cn/nix-channels/store"
    ];
    trusted-users = ["@wheel"];
    experimental-features = ["nix-command" "flakes" "repl-flake"];
  };

  #######################################################################
  ## Essential Apps
  #######################################################################
  environment.systemPackages = with pkgs; [
    binutils
    tree
    file
    p7zip
    fd
    ripgrep
    gdu
    duf
    neofetch
    parted
    gptfdisk
    wget
    bind
    git
    nix-bash-completions
    bcachefs-tools

    vim
    micro
    fish
    btop
    ydict
    unp
    unrar
    ouch
    ipinfo
  ];

  time.timeZone = "Asia/Shanghai";
}
