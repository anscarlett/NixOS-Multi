{
  description = "NIX SAVE THE WORLD";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    # nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-22.05";
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

    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # hyprland = {
    #   url = "github:hyprwm/Hyprland";
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

    # agenix.url = github:ryantm/agenix;
    # sops-nix.url = github:Mic92/sops-nix;
    # nur.url = "github:nix-community/NUR";
    templates.url = "github:NixOS/templates";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # dream2nix.url = "github:nix-community/dream2nix";
    # dream2nix.inputs.nixpkgs.follows = "nixpkgs";

    # nix-npm-buildpackage.url = "github:serokell/nix-npm-buildpackage";
    # nix-npm-buildpackage.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    # nixpkgs-stable,
    nixos-wsl,
    home-manager,
    flake-parts,
    ...
  }: let
    overlays = [
      # inputs.nur.overlay
      self.overlays.default
      # (final: prev: {
      #   stable = nixpkgs-stable.legacyPackages.${prev.system};
      # })
    ];

    lib = nixpkgs.lib.extend (final: prev:
      import ./lib {
        inherit inputs;
        lib = final;
      });
  in
    flake-parts.lib.mkFlake {inherit inputs;} {
      flake = {
        overlays.default = import ./overlays;

        nixosModules = import ./nixos;

        nixosConfigurations = {
          # nixos-rebuild --use-remote-sudo --flake .#yoga
          yoga = lib.mkHost {
            username = "iab";
            hostname = "yoga";
            inherit overlays;
            extraModules = [
              ./nixos/desktop/gnome.nix

              ({
                inpouts,
                config,
                pkgs,
                ...
              }: {
                # disabledModules = ["config/swap.nix"];
                # imports = [
                #   "${inputs.nixpkgs-pr}/nixos/modules/config/swap.nix"
                # ];
                # environment.systemPackages = with pkgs; [
                #   # nixpkgs-pr.legacyPackages.${system}.gnomeExtensions.pano
                # ];
              })
            ];
          };

          # nixos-rebuild --target-host zendo@192.168.2.198 --use-remote-sudo --flake .#svp boot
          svp = lib.mkHost {
            username = "zendo";
            hostname = "svp";
            # nixpkgs = inputs.nixpkgs-stable;
            inherit overlays;
            extraModules = [
              ./nixos/desktop/gnome.nix
            ];
          };

          # nix build .#wsl-installer
          wsl = lib.mkHost {
            username = "iab";
            hostname = "wsl";
            inherit overlays;
            defaultModules = false;
            extraModules = [
              nixos-wsl.nixosModules.wsl
              ./nixos/fonts.nix
              ./nixos/nixconfig.nix
            ];
          };

          # nixos-rebuild build-vm --flake .#vmtest
          vmtest = lib.mkHost {
            username = "test";
            hostname = "vmtest";
            inherit overlays;
            # nixpkgs = inputs.nixpkgs-pr;
          };

          # nix build .#livecd-iso
          livecd = lib.mkHost {
            username = "livecd";
            hostname = "livecd";
            inherit overlays;
          };
        };

        #######################################################################
        ##  Home-Manager Standalone
        #######################################################################
        homeConfigurations = {
          # non-nixos
          iab = lib.mkHome {
            username = "iab";
            inherit overlays;
            extraModules = [
              ./nixos/desktop/hm-dconf.nix
            ];
          };
          # other user at nixos
          guest = lib.mkHome {
            username = "guest";
            inherit overlays;
            extraModules = [
              ./home-manager/gui.nix
              ./home-manager/bash.nix
              ./home-manager/editor.nix
              ./home-manager/browsers.nix
            ];
          };
        };

        # nix run github:serokell/deploy-rs -- -s .
        deploy = {
          sudo = "doas -u";
          autoRollback = false;
          magicRollback = false;
          nodes = {
            "svp" = {
              hostname = "192.168.2.198";
              profiles.system = {
                user = "root";
                sshUser = "zendo";
                path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations."svp";
              };
            };
          };
        };

        # for easily repl
        inherit lib inputs;
        pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
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
          inherit system overlays;
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

  # auto-fetch deps when `nix run/shell/develop`
  nixConfig = {
    bash-prompt = "[nix]λ ";
    # substituters = ["https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"];
    # extra-substituters = ["https://nix-gaming.cachix.org"];
    # extra-trusted-public-keys = ["nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="];
  };
}
