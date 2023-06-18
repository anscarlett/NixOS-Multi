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
        services.xserver.displayManager.autoLogin.user = "${username}";
        networking.hostName = "${hostname}";

        documentation.enable = false;
        programs.command-not-found.enable = false;

        time.timeZone = "Asia/Shanghai";
        system.stateVersion = "23.11";
      }

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {inherit hostname username inputs;};
        home-manager.users.${username} = import ../home-manager;
      }

      inputs.disko.nixosModules.disko
    ]
    ++ nixpkgs.lib.optionals defaultModules [
      self.nixosModules.default
    ]
    ++ extraModules;
}
