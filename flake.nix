{
  description = "NIX SAVE THE WORLD";

  outputs =
    inputs@{
      self,
      nixpkgs,
      flake-parts,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      imports = [ inputs.devenv.flakeModule ];

      flake = {
        nixosModules = import ./nixos;

        overlays = import ./overlays { inherit inputs; };

        nixosConfigurations = import ./hosts { inherit inputs self; };

        homeConfigurations = import ./home-manager/hm-standalone.nix { inherit inputs; };

        deploy = import ./hosts/deployment.nix { inherit inputs; };

        templates = import ./templates;

        # quickly repl
        inherit inputs;
        inherit (inputs.nixpkgs) lib;
        flake = builtins.getFlake (toString ./.);
        hosts = self.nixosConfigurations;
        hm = self.nixosConfigurations.yoga.config.home-manager.users;
        n = nixpkgs.legacyPackages.x86_64-linux;
      };

      perSystem =
        {
          inputs',
          pkgs,
          system,
          ...
        }:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = builtins.attrValues self.overlays;
            config = {
              allowUnfree = true;
              # allowBroken = true;
              # allowInsecure = true;
              # allowUnsupportedSystem = true;
            };
          };
        in
        {
          # nix build .#apps
          # access pkgs from self & overlays
          legacyPackages = pkgs;

          # nix fmt
          formatter = pkgs.nixfmt-rfc-style;

          # nix run .
          packages.default = pkgs.ns-cli;

          # nix develop .#rust
          devShells = import ./devshells.nix { inherit pkgs; };

          # nix develop --impure .#rust-env
          devenv.shells = import ./devenvs.nix { inherit pkgs; };
        };
    };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    # nixpkgs-temp.url = "github:NixOS/nixpkgs/5a8e9243812ba528000995b294292d3b5e120947";
    # nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.05";
    # nixpkgs.url = "github:NixOS/nixpkgs/pull/213619/merge";
    # nixpkgs.url = "git+file:///home/iab/dev/nixpkgs/?ref=upd/notes";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # lanzaboote = {
    #   url = "github:nix-community/lanzaboote";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # nur.url = "github:nix-community/NUR";
    # agenix.url = "github:ryantm/agenix";
    sops-nix.url = "github:Mic92/sops-nix";
    devenv.url = "github:cachix/devenv";
    templates.url = "github:NixOS/templates";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  # auto-fetch deps when `nix run/shell/develop`
  nixConfig = {
    bash-prompt = "[nix]λ ";
    # substituters = ["https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"];
    # extra-substituters = ["https://nix-gaming.cachix.org"];
    # extra-trusted-public-keys = ["nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="];
  };
}
