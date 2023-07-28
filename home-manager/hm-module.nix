{
  lib,
  nixosConfig,
  ...
}: {
  imports =
    [
      ./git.nix
      ./cli.nix
      ./xdg.nix
      ./zsh.nix
      ./bash.nix
      ./tmux.nix
      ./alias.nix
    ]
    ++ lib.optionals nixosConfig.services.xserver.enable [
      ./gui.nix
      ./editor.nix
      ./browsers.nix
      ./mods/polkit.nix
    ]
    ++ lib.optionals nixosConfig.services.xserver.desktopManager.gnome.enable [
      ./dconf.nix
    ]
    ++ lib.optionals nixosConfig.services.xserver.desktopManager.plasma5.enable [
      ./kderc.nix
    ];

  home.stateVersion = nixosConfig.system.stateVersion;
}
