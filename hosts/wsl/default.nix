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
    kitty
    # alacritty
    emacs
    goodvibes
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # zsh
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  #######################################################################
  ##  Home Manager
  #######################################################################
  home-manager.users.${username} = {
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
