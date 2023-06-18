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

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {inherit hostname username inputs;};
        home-manager.users.${username} = import ../home-manager;
      }
    ]
    ++ nixpkgs.lib.optionals defaultModules [
      self.nixosModules.default
    ]
    ++ extraModules;
}
