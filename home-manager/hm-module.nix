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
      ./modules/polkit.nix
    ];

  home.stateVersion = nixosConfig.system.stateVersion;
}
