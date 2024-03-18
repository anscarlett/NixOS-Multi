/*
  # non-nixos setup
  sudo vi /etc/nix/nix.conf
  experimental-features = nix-command flakes
  trusted-users = root @wheel iab
  substituters = https://mirror.sjtu.edu.cn/nix-channels/store
*/
{ pkgs, inputs, ... }:
{
  home.shellAliases = {
    nixgl = "nix run --impure github:guibou/nixGL";
  };

  home.packages = with pkgs; [
    dippi
    goodvibes
  ];

  programs.home-manager.enable = true;

  nix = {
    registry = {
      self.flake = inputs.self;
      nixpkgs.flake = inputs.nixpkgs;
      n.flake = inputs.nixpkgs;
    };
    package = pkgs.nixVersions.unstable; # need for nix.settings
    settings = {
      warn-dirty = false;
      experimental-features = [
        "flakes"
        "nix-command"
      ];
    };
  };
}
