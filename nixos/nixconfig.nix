{
  lib,
  inputs,
  ...
}: {
  nix = {
    # nix registry list
    registry =
      lib.mapAttrs (_: value: {flake = value;}) inputs
      // {
        n.flake = inputs.nixpkgs;
      };

    # compatible for old nix
    # echo $NIX_PATH | tr ":" "\n"
    nixPath =
      lib.mapAttrsToList (name: path: "${name}=${path}") inputs
      ++ [
        "nixos-config=${inputs.self}"
      ];

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 5d";
    };

    settings = {
      # keep-outputs = true
      # keep-derivations = true
      warn-dirty = false;
      auto-optimise-store = true;
      flake-registry = /etc/nix/registry.json;

      substituters = lib.mkForce [
        "https://mirror.sjtu.edu.cn/nix-channels/store"
        # "https://mirrors.sjtug.sjtu.edu.cn/nix-channels/store"
        # "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store?priority=30"
        # "https://mirrors.ustc.edu.cn/nix-channels/store"
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];

      trusted-users = ["root" "@wheel"];
      # List of binary cache URLs that non-root users can use
      trusted-substituters = [
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];

      experimental-features = [
        "nix-command"
        "flakes"
        "repl-flake"
      ];
    };
  };
}
