{
  inputs,
  overlays,
}: let
  mkHost = {
    hostname,
    username,
    nixpkgs ? inputs.nixpkgs,
    system ? "x86_64-linux",
    overlays ? [],
    defaultModules ? true,
    extraModules ? [],
  }:
    nixpkgs.lib.nixosSystem {
      inherit system;

      specialArgs = {inherit inputs username;};

      modules =
        [
          {
            nixpkgs.overlays = overlays;
            nixpkgs.config.allowUnfree = true;
            networking.hostName = "${hostname}";
            services.xserver.displayManager.autoLogin.user = "${username}";
          }

          inputs.disko.nixosModules.disko

          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {inherit hostname username inputs;};
            home-manager.users.${username} = import ../home-manager/hm-module.nix;
          }
        ]
        ++ nixpkgs.lib.optionals defaultModules [
          inputs.self.nixosModules.default
        ]
        ++ extraModules;
    };
in {
  # nixos-rebuild --use-remote-sudo --flake .#yoga
  yoga = mkHost {
    username = "iab";
    hostname = "yoga";
    inherit overlays;
    extraModules = [
      ./yoga
      inputs.self.nixosModules.gnome
      # inputs.self.nixosModules.sway

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
  svp = mkHost {
    username = "zendo";
    hostname = "svp";
    # nixpkgs = inputs.nixpkgs-stable;
    inherit overlays;
    extraModules = [
      ./svp
      inputs.self.nixosModules.gnome
    ];
  };

  # nixos-rebuild build-vm --flake .#vmtest
  vmtest = mkHost {
    username = "test";
    hostname = "vmtest";
    inherit overlays;
    extraModules = [
      ./vmtest
    ];
  };

  # nix build .#livecd-iso
  livecd = mkHost {
    username = "livecd";
    hostname = "livecd";
    inherit overlays;
    extraModules = [
      ./livecd
    ];
  };

  # nix build .#wsl-installer
  wsl = mkHost {
    username = "iab";
    hostname = "wsl";
    inherit overlays;
    defaultModules = false;
    extraModules = [
      ./wsl
      ../nixos/fonts.nix
      ../nixos/nixconfig.nix
      inputs.nixos-wsl.nixosModules.wsl
    ];
  };
}
