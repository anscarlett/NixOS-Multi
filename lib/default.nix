# https://github.com/tejing1/nixos-config/tree/master/lib
{ inputs, ... }:
import ./attrsets.nix { inherit (inputs.nixpkgs) lib; }
// import ./umport.nix { inherit (inputs.nixpkgs) lib; }
