set shell := ["bash", "-cu"]

# alias c := check
# alias b := build

host := `uname -n`
user := `loginctl --no-legend list-users | awk '{print $2;}'`

default:
    @just --choose

os-boot:
    nixos-rebuild --use-remote-sudo --flake .#"{{host}}" boot

os-switch:
    nixos-rebuild --use-remote-sudo --flake .#"{{host}}" switch

os-upgrade:
    nix flake update && \
    nixos-rebuild --use-remote-sudo --flake .#"{{host}}" boot

hm-switch:
    nix run nixpkgs#home-manager switch -- \
      --flake .#"{{user}}"

build-livecd-graphical:
    nix build .#nixosConfigurations.livecd-graphical.config.system.build.isoImage

build-livecd-minimal:
    nix build .#nixosConfigurations.livecd-minimal.config.system.build.isoImage

nix-index-database-update:
    #!/usr/bin/env bash
    filename="index-x86_64-$(uname | tr '[:upper:]' '[:lower:]')"
    mkdir -p ~/.cache/nix-index
    pushd ~/.cache/nix-index > /dev/null
    wget -q -N https://github.com/nix-community/nix-index-database/releases/latest/download/"$filename"
    ln -f "$filename" files
    popd > /dev/null
    ls -l ~/.cache/nix-index
