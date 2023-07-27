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
      specialArgs = {inherit inputs self username;};
      modules =
        [
          inputs.disko.nixosModules.disko
          inputs.home-manager.nixosModules.home-manager
          {
            nixpkgs.config.allowUnfree = true;
            nixpkgs.overlays = builtins.attrValues self.overlays;
            networking.hostName = "${hostname}";
            services.xserver.displayManager.autoLogin.user = "${username}";

            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {inherit inputs;};
              users.${username} = import ../home-manager/hm-module.nix;
            };
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
    ];
  };

  # nixos-rebuild --target-host zendo@192.168.2.198 --use-remote-sudo --flake .#svp boot
  svp = mkHost {
    username = "zendo";
    hostname = "svp";
    # nixpkgs = inputs.nixpkgs-stable;
    extraModules = [
      ./svp
    ];
  };

  # remote machine test @ qemu
  rmt = mkHost {
    username = "aaa";
    hostname = "rmt";
    extraModules = [
      ./rmt
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

  # nix build .#nixosConfigurations.vanilla.config.system.build.isoImage
  vanilla = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {inherit inputs;};
    system = "x86_64-linux";
    modules = [
      ./vanilla
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
