{
  inputs,
  self,
}: let
  mkHost = {
    hostname,
    username,
    nixpkgs ? inputs.nixpkgs,
    system ? "x86_64-linux",
    defaultModules ? true,
    extraModules ? [],
  }:
    nixpkgs.lib.nixosSystem {
      inherit system;

      specialArgs = {inherit inputs username;};

      modules =
        [
          {
            networking.hostName = "${hostname}";
            services.xserver.displayManager.autoLogin.user = "${username}";
            nixpkgs.config.allowUnfree = true;
            nixpkgs.overlays = builtins.attrValues self.overlays;
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
          self.nixosModules.default
        ]
        ++ extraModules;
    };
in {
  # nixos-rebuild --use-remote-sudo --flake .#yoga
  yoga = mkHost {
    username = "iab";
    hostname = "yoga";
    extraModules = [
      ./yoga
      self.nixosModules.gnome
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
    extraModules = [
      ./svp
      self.nixosModules.gnome
    ];
  };

  # nixos-rebuild build-vm --flake .#vmtest
  vmtest = mkHost {
    username = "test";
    hostname = "vmtest";
    extraModules = [
      ./vmtest
    ];
  };

  # nix build .#nixosConfigurations.livecd.config.system.build.isoImage
  livecd = mkHost {
    username = "livecd";
    hostname = "livecd";
    extraModules = [
      ./livecd
    ];
  };

  # nix build .#nixosConfigurations.wsl.config.system.build.installer
  wsl = mkHost {
    username = "iab";
    hostname = "wsl";
    defaultModules = false;
    extraModules = [
      ./wsl
      ../nixos/fonts.nix
      ../nixos/nixconfig.nix
      inputs.nixos-wsl.nixosModules.wsl
    ];
  };
}
