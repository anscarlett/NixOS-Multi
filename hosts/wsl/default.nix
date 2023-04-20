{
  pkgs,
  username,
  ...
}: {
  wsl = {
    enable = true;
    defaultUser = "${username}";
    startMenuLaunchers = true;
    nativeSystemd = true;

    # Enable native Docker support
    # docker-native.enable = true;

    # Enable integration with Docker Desktop (needs to be installed)
    # docker-desktop.enable = true;
  };

  networking.hostName = "wsl";

  environment.systemPackages = with pkgs; [
    binutils
    tree
    file
    parted
    gptfdisk
    wget
    nix-bash-completions

    # Gui
    # foot
    # kitty
    alacritty
    emacs
    goodvibes
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  users.defaultUserShell = pkgs.zsh;

  # for zsh completion in home-manager
  environment.pathsToLink = ["/share/zsh"];

  programs.zsh.enable = true;

  documentation.enable = false;

  programs.command-not-found.enable = false;

  time.timeZone = "Asia/Shanghai";

  system.stateVersion = "22.05";

  #######################################################################
  ##  Home Manager
  #######################################################################
  home-manager.users.${username} = {
    config,
    pkgs,
    ...
  }: {
    home.packages = with pkgs; [
      wslu
      wsl-open
    ];

    home.shellAliases = {
      wsl-proxy = "export {http,https,ftp}_proxy=192.168.2.118:7890 ; \\
        export {HTTP,HTTPS,FTP}_PROXY=192.168.2.118:7890";
    };
  };
}
