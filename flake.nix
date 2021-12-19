{
  description = "Yoga14s NixOS Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nur = {
    #   url = "github:nix-community/NUR";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # nixos-cn = {
    #   url = "github:nixos-cn/flakes";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # flake-utils.url = "github:numtide/flake-utils";

    emacs-overlay.url = "github:nix-community/emacs-overlay";
  };


  outputs =
    { self
    , nixpkgs
    , home-manager
    , ...
    }@inputs:

    # let
    #   system = "x86_64-linux";

    #   pkgs = import nixpkgs {
    #     inherit system;
    #     overlays = [ inputs.emacs-overlay.overlay ];
    #     nixpkgs.config = {
    #       allowUnfree = true;
    #       allowBroken = true;
    #       allowUnsupportedSystem = true;
    #     };
    #   };

    #   lib = nixpkgs.lib;

    # in
    {
      # homeManagerConfigurations = {
      #   iab = home-manager.lib.homeManagerConfiguration {
      #     inherit system pkgs;
      #     username = "iab";
      #     homeDirectory = "/home/iab";
      #     configuration = {
            
      #       imports = [
      #         ./home.nix
      #       ];
      #     };
      #   };
      # };

      # nixosConfigurations = {
      #   nix = lib.nixosSystem {
      #     inherit system;
      #     modules = [
      #       ./modules/hardware-configuration.nix
      #       ./modules/amd.nix
      #       # ./modules/intel.nix
      #       ./modules/gnome.nix
      #       # ./modules/kde.nix
      #       ./modules/iab.nix
      #       ./configuration.nix
      #     ];
      #   };
      # };

      nixosConfigurations = {
        "nix" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./modules/hardware-configuration.nix
            ./modules/amd.nix
            # ./modules/intel.nix
            # ./modules/kde.nix
            ./modules/gnome.nix
            ./modules/iab.nix
            ./configuration.nix

            {
              nixpkgs.overlays = [ inputs.emacs-overlay.overlay ];
              nixpkgs.config = {
                allowUnfree = true;
                allowBroken = true;
                allowUnsupportedSystem = true;
              };
            }


            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.iab = import ./home.nix;
            }
          ];
        };

        # "nix2" = nixpkgs.lib.nixosSystem {
        #   system = "x86_64-linux";
        #   modules = [
        #     ./configuration2.nix
        #   ];
        # };

      };
    };
}
