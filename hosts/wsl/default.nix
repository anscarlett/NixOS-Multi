/*
  wsl --import NixOS $env:USERPROFILE\NixOS\ nixos-wsl.tar.gz
  wsl --unregister nixos
*/
{ pkgs, username, ... }:
{
  home-manager.users.${username} = {
    home.packages = with pkgs; [
      wslu
      wsl-open
      # GUI
      kitty
      goodvibes
      # emacs29-pgtk
    ];

    home.shellAliases = {
      wsl-proxy = ''
        export {http,https,ftp}_proxy=192.168.2.118:7890 ; \
                export {HTTP,HTTPS,FTP}_PROXY=192.168.2.118:7890'';
    };
  };

  wsl = {
    enable = true;
    defaultUser = "${username}";
    startMenuLaunchers = true;

    # Enable native Docker support
    # docker-native.enable = true;

    # Enable integration with Docker Desktop (needs to be installed)
    # docker-desktop.enable = true;
  };

  environment.systemPackages = with pkgs; [
    binutils
    tree
    file
    wget
    nix-bash-completions
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # zsh
  programs.zsh.enable = true;
  # users.defaultUserShell = pkgs.zsh;

  programs.command-not-found.enable = false;
  documentation.enable = false;
  time.timeZone = "Asia/Shanghai";
  system.stateVersion = "24.05";
}
