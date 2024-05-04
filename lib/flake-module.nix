{ inputs, ... }:
{
  flake.lib = inputs.nixpkgs.lib.extend (
    final: prev: {
      mylib = import ./. {
        inherit inputs;
        lib = final;
      };
    }
  );
}
