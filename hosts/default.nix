{ inputs, self }:
let
  mkHost =
    {
      hostname,
      username,
      nixpkgs ? inputs.nixpkgs,
      system ? "x86_64-linux",
      defaultModules ? true,
      hmEnable ? true,
      extraModules ? [ ],
    }:
    nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs self username;
      };
      modules =
        [
          # sops-nix modules
          inputs.sops-nix.nixosModules.sops
          {
            sops.defaultSopsFile = ../secrets/secrets.yaml;
            sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
            # sops.age.generateKey = true;
            sops.age.keyFile = "/home/${username}/.config/sops/age/keys.txt";
          }
          # disko modules
          inputs.disko.nixosModules.disko
          {
            networking.hostName = "${hostname}";
            services.xserver.displayManager.autoLogin.user = "${username}";
          }
        ]
        ++ nixpkgs.lib.optionals hmEnable [
          # home-manager modules
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {
                inherit inputs;
              };
              users.${username} = import ../home-manager/hm-module.nix;
            };
          }
        ]
        ++ nixpkgs.lib.optionals defaultModules [ self.nixosModules.default ]
        ++ extraModules;
    };
in
{
  # nixos-rebuild --use-remote-sudo --flake .#yoga
  yoga = mkHost {
    username = "iab";
    hostname = "yoga";
    extraModules = [ ./yoga ];
  };

  # nixos-rebuild --target-host zendo@192.168.2.198 --use-remote-sudo --flake .#svp boot
  svp = mkHost {
    username = "zendo";
    hostname = "svp";
    # nixpkgs = inputs.nixpkgs-stable;
    extraModules = [ ./svp ];
  };

  # remote machine test @ qemu
  rmt = mkHost {
    username = "aaa";
    hostname = "rmt";
    # hmEnable = false;
    extraModules = [ ./rmt ];
  };

  # nixos-rebuild build-vm --flake .#vmtest
  vmtest = mkHost {
    username = "test";
    hostname = "vmtest";
    extraModules = [ ./vmtest ];
  };

  # nix build .#nixosConfigurations.livecd-graphical.config.system.build.isoImage
  livecd-graphical = mkHost {
    username = "livecd";
    hostname = "livecd";
    extraModules = [ ./livecd/graphical.nix ];
  };

  # nix build .#nixosConfigurations.livecd-minimal.config.system.build.isoImage
  livecd-minimal = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit inputs;
    };
    system = "x86_64-linux";
    modules = [ ./livecd/minimal.nix ];
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
