inputs: let
  inherit (inputs) self nixpkgs nixpkgs-stable home-manager;
in
  {
    hostname,
    username,
    nixpkgs ? inputs.nixpkgs,
    system ? "x86_64-linux",
    hmEnable ? true,
    overlays ? [],
    extraModules ? [],
  }:
    nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {inherit inputs username;};
      modules =
        [
          ../hosts/${hostname}

          self.nixosModules.default

          {
            nixpkgs.overlays = overlays;

            networking.hostName = "${hostname}";

            services.xserver.displayManager.autoLogin.user = "${username}";
            # Fix: https://nixos.wiki/wiki/GNOME
            systemd.services."getty@tty1".enable = false;
            systemd.services."autovt@tty1".enable = false;
          }
        ]
        ++ nixpkgs.lib.optionals hmEnable [
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {inherit hostname inputs;};
            home-manager.users.${username} = import ../home-manager;
          }
        ]
        ++ extraModules;
    }
