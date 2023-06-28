{
  inputs,
  overlays,
}: let
  mkHome = {
    username,
    nixpkgs ? inputs.nixpkgs,
    system ? "x86_64-linux",
    overlays ? [],
    extraModules ? [],
  }:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        inherit system overlays;
        config.allowUnfree = true;
      };

      extraSpecialArgs = {inherit inputs;};

      modules =
        [
          ./git.nix
          ./cli.nix
          ./xdg.nix
          ./zsh.nix
          ./tmux.nix
          ./alias.nix
          ./non-nixos.nix

          {
            home.username = "${username}";
            home.homeDirectory = "/home/${username}";
            home.stateVersion = "23.11";
          }
        ]
        ++ extraModules;
    };
in {
  # non-nixos
  iab = mkHome {
    username = "iab";
    inherit overlays;
    extraModules = [
      ../nixos/desktop/hm-dconf.nix
    ];
  };

  # other user at nixos
  guest = mkHome {
    username = "guest";
    inherit overlays;
    extraModules = [
      ./gui.nix
      ./bash.nix
      ./editor.nix
      ./browsers.nix
    ];
  };
}
