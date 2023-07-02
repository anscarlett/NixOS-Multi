# https://github.com/tejing1/nixos-config/tree/master/lib
inputs: let
  inherit (inputs.nixpkgs) lib;
in rec {
  supportedSystems = ["aarch64-linux" "x86_64-linux"];

  genSystems = lib.genAttrs supportedSystems;

  nixpkgsFor = genSystems (system: overlays:
    import inputs.nixpkgs {
      inherit system overlays;
    });

  # Filter files that have the .nix suffix
  filterNixFiles = k: v: v == "regular" && lib.hasSuffix ".nix" k;
  # Import files that are selected by filterNixFiles
  importNixFiles = path:
    (lib.lists.forEach (lib.mapAttrsToList (name: _: path + ("/" + name))
        (lib.filterAttrs filterNixFiles (builtins.readDir path))))
    import;

  /*

  # TODO
  btrfsInInitrd = lib.any (fs: fs == "btrfs") builtins.config.boot.initrd.supportedFilesystems;
  btrfsInSystem = lib.any (fs: fs == "btrfs") builtins.config.boot.supportedFilesystems;
  btrfsEnable = btrfsInInitrd && btrfsInSystem;

  zfsUsed = lib.lists.elem "zfs" (config.boot.supportedFilesystems ++ config.boot.initrd.supportedFilesystems);
  boot.kernelPackages = lib.mkDefault (
    if zfsUsed
    then pkgs.zfs.latestCompatibleLinuxPackages
    else pkgs.linuxPackages_latest
  );
  */
}
