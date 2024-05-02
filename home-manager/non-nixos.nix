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
    package = pkgs.nixVersions.latest; # need for nix.settings
    settings = {
      warn-dirty = false;
      experimental-features = [
        "flakes"
        "nix-command"
      ];
    };
  };
}
