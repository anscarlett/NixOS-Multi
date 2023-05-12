inputs @ {
  self,
  nixpkgs,
  home-manager,
  ...
}: {
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

  pkgs = import nixpkgs {
    inherit system overlays;
    config = {
      allowUnfree = true;
      # allowBroken = true;
      # allowInsecure = true;
      # allowUnsupportedSystem = true;
    };
  };

  specialArgs = {inherit inputs username;};

  modules =
    [
      ../hosts/${hostname}

      {
        system.stateVersion = "22.05";
        networking.hostName = "${hostname}";
      }

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {inherit hostname inputs;};
        home-manager.users.${username} = import ../home-manager;
      }
    ]
    ++ nixpkgs.lib.optionals defaultModules [
      {
        services.xserver.displayManager.autoLogin.user = "${username}";
      }
      self.nixosModules.default
    ]
    ++ extraModules;
}
