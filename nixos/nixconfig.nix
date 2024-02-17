{
  lib,
  inputs,
  pkgs,
  ...
}:
{
  nixpkgs = {
    config.allowUnfree = true;
    overlays = builtins.attrValues inputs.self.overlays;
  };

  nix = {
    # channel.enable = false;

    # nix registry list
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs // {
      n.flake = inputs.nixpkgs;
    };

    # nix show-config nix-path
    # echo $NIX_PATH | tr ":" "\n"
    nixPath = lib.mapAttrsToList (name: path: "${name}=${path}") inputs ++ [
      "nixos-config=${inputs.self}"
    ];

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 5d";
    };

    # 2.19
    package = pkgs.nixVersions.unstable;

    settings = {
      # keep-outputs = true
      # keep-derivations = true
      warn-dirty = false;
      auto-optimise-store = true;
      auto-allocate-uids = true;
      use-cgroups = true;
      flake-registry = ""; # disable global registry

      substituters = [
        # "https://mirror.sjtu.edu.cn/nix-channels/store"
        # "https://mirrors.ustc.edu.cn/nix-channels/store"
        # "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
        # "https://cache.nixos.org"
        # "https://aseipp-nix-cache.freetls.fastly.net"
        "https://nix-community.cachix.org"
      ];

      trusted-users = [
        "root"
        "@wheel"
      ];
      # List of binary cache URLs that non-root users can use
      trusted-substituters = [ ];
      trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];

      # impureEnvVars = [
      #   "http_proxy"
      #   "https_proxy"
      # ];

      experimental-features = [
        "flakes"
        "nix-command"
        "configurable-impure-env"

        # Allows Nix to automatically pick UIDs for builds, rather than creating nixbld* user accounts
        "auto-allocate-uids"

        # Allows Nix to execute builds inside cgroups
        "cgroups"
      ];
    };
  };
}
