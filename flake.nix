{
  description = "NIX SAVE THE WORLD";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    # nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-22.05";
    # nixpkgs.url = "github:NixOS/nixpkgs/pull/213619/merge";
    # nixpkgs.url = "git+file:///home/iab/dev/nixpkgs/?ref=fix/colord-kde";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay/a160e897d1f9f3b0fedf191a79d8ab99a09bcfd6";
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
      inputs.emacs-overlay.overlay
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
          yoga = lib.mkHost {
            username = "iab";
            hostname = "yoga";
            inherit overlays;
            extraModules = [
              ./nixos/gnome.nix
              # ./nixos/kde.nix
              # ./nixos/wm-sway.nix
              # ./nixos/wm-hyprland.nix

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
            # hmEnable = false;
            # nixpkgs = inputs.nixpkgs-stable;
            inherit overlays;
            extraModules = [
              # ./nixos/gnome.nix
              ./nixos/kde.nix
              # ./nixos/wm-sway.nix
            ];
          };

          # nixos-rebuild build-vm --flake .#vmtest
          vmtest = lib.mkHost {
            username = "test";
            hostname = "vmtest";
            # hmEnable = false;
            inherit overlays;
            # nixpkgs = inputs.nixpkgs-pr;
          };

          # nix build .#livecd-iso
          livecd = lib.mkHost {
            username = "livecd";
            hostname = "livecd";
            inherit overlays;
            extraModules = [
              {programs.my-virt.enable = false;}
            ];
          };

          #####################################################################
          ##  WSL
          #####################################################################
          wsl = let
            username = "iab";
          in
            nixpkgs.lib.nixosSystem {
              system = "x86_64-linux";
              specialArgs = {inherit inputs username;};
              modules = [
                ./hosts/wsl
                ./nixos/fonts.nix
                ./nixos/nixconfig.nix

                nixos-wsl.nixosModules.wsl
                {
                  nixpkgs.overlays = overlays;
                  nixpkgs.config.allowUnfree = true;
                }

                home-manager.nixosModules.home-manager
                {
                  home-manager.useGlobalPkgs = true;
                  home-manager.useUserPackages = true;
                  home-manager.extraSpecialArgs = {inherit inputs;};
                  home-manager.users.${username} = import ./home-manager;
                }
              ];
            };
        };

        #######################################################################
        ##  Home-Manager Standalone
        #######################################################################
        homeConfigurations = {
          iab = lib.mkHome {
            username = "iab";
            inherit overlays;
          };
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

        # for easily repl
        inherit lib inputs;
        pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;

        # for easily build
        wsl-installer = self.nixosConfigurations.wsl.config.system.build.installer;
        livecd-iso = self.nixosConfigurations.livecd.config.system.build.isoImage;
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
