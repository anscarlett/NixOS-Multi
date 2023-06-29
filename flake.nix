{
  description = "NIX SAVE THE WORLD";

  outputs = inputs @ {
    self,
    nixpkgs,
    flake-parts,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      flake = {
        nixosModules = import ./nixos;

        overlays = import ./overlays {inherit inputs;};

        nixosConfigurations = import ./hosts {inherit inputs self;};

        homeConfigurations = import ./home-manager/hm-standalone.nix {inherit inputs;};

        deploy = import ./hosts/deployment.nix {inherit inputs;};

        # for easily repl
        inherit inputs;
        inherit (inputs.nixpkgs) lib;
        n = inputs.nixpkgs.legacyPackages.x86_64-linux;
        hm = self.nixosConfigurations.yoga.config.home-manager.users;

        # for easily build
        livecd-iso = self.nixosConfigurations.livecd.config.system.build.isoImage;
        wsl-installer = self.nixosConfigurations.wsl.config.system.build.installer;
      };

      debug = true;

      systems = ["x86_64-linux" "aarch64-linux"];

      perSystem = {
        inputs',
        pkgs,
        system,
        ...
      }: let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            self.overlays.default
          ];
          config = {
            allowUnfree = true;
            # allowBroken = true;
            # allowInsecure = true;
            # allowUnsupportedSystem = true;
          };
        };
      in {
        # nix build .#apps or self#apps / nix run self#apps
        legacyPackages = pkgs;

        # nix fmt
        formatter = pkgs.alejandra;

        # nix run . -- hmswitch
        packages.default = pkgs.ns-cli;

        # nix develop .#rust
        devShells = import ./devshells.nix {inherit pkgs;};
      };
    };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    # nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.05";
    # nixpkgs.url = "github:NixOS/nixpkgs/pull/213619/merge";
    # nixpkgs.url = "git+file:///home/iab/dev/nixpkgs/?ref=pr-232373";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

    # hyprland = {
    #   url = "github:hyprwm/Hyprland";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # agenix.url = github:ryantm/agenix;
    # sops-nix.url = github:Mic92/sops-nix;
    # nur.url = "github:nix-community/NUR";
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
