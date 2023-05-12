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
  extraModules ? [],
}:
nixpkgs.lib.nixosSystem {
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
      self.nixosModules.default

      ../hosts/${hostname}

      {
        networking.hostName = "${hostname}";
        services.xserver.displayManager.autoLogin.user = "${username}";
      }

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
