inputs: {
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

  modules =
    [
      ../home-manager/git.nix
      ../home-manager/cli.nix
      ../home-manager/xdg.nix
      ../home-manager/zsh.nix
      ../home-manager/tmux.nix
      ../home-manager/alias.nix
      ../home-manager/dconf.nix
      ../home-manager/non-nixos.nix

      {
        home.stateVersion = "22.05";
        home.username = "${username}";
        home.homeDirectory = "/home/${username}";
      }
    ]
    ++ extraModules;
}
