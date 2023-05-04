inputs: let
  inherit (inputs) self home-manager;
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
          self.nixosModules.default

          ../hosts/${hostname}

          {
            networking.hostName = "${hostname}";

            nixpkgs.overlays = overlays;

            nixpkgs.config = {
              allowUnfree = true;
              # allowBroken = true;
              # allowInsecure = true;
              # allowUnsupportedSystem = true;
            };

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
