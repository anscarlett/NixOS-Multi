#!/usr/bin/env bash

set -euo pipefail

dotConfig=~/nsworld

# getUser=$(id -u -n)
getUser=$(loginctl --no-legend list-users | awk '{print $2;}')

getHost=$(uname -n)

ns_usage() {
    cat <<EOF

Usage:
 which log references depends
 boot switch upgrade diff
 profiles generations source installed
 pr-run pr-shell pr-pull git-fm
 hmswitch hmsource hmprofiles hmdiff
EOF
}

# Check for arguments
if [ $# -eq 0 ]; then
    ns_usage
    exit 1
fi

while [[ $# -gt 0 ]]; do
    case "$1" in

        which)
            readlink -f "$(which "$2")"
            shift ;;

        log)
            nix log "$(readlink -f "$(which "$2")")"
            shift ;;

        boot)
            nixos-rebuild --use-remote-sudo --flake $dotConfig#"$getHost" boot
            shift ;;

        switch)
            nixos-rebuild --use-remote-sudo --flake $dotConfig#"$getHost" switch
            shift ;;

        upgrade)
            nixos-rebuild --use-remote-sudo --flake $dotConfig#"$getHost" boot \
                --recreate-lock-file
            shift ;;

        hmswitch)
            nix run nixpkgs#home-manager switch -- \
                --flake $dotConfig#"$getUser"
            shift ;;

        hmsource)
            readlink -f /nix/var/nix/profiles/per-user/"$getUser"/home-manager
            shift ;;

        hmprofiles)
            ls -la /nix/var/nix/profiles/per-user/"$getUser"
            shift ;;

        hmdiff)
            nix profile diff-closures --profile \
                /nix/var/nix/profiles/per-user/"$getUser"/home-manager
            shift ;;

        diff)
            nix profile diff-closures --profile \
                /nix/var/nix/profiles/system
            shift ;;

        source)
            readlink -f /nix/var/nix/profiles/system
            shift ;;

        installed)
            nix path-info --recursive /run/current-system | cut -b 45- | sort
            shift ;;

        profiles)
            ls -la /nix/var/nix/profiles
            shift ;;

        generations)
            nix profile history --profile /nix/var/nix/profiles/system
            shift ;;

        references)
            nix-store -q --references "$2"
            shift ;;

        depends)
            nix path-info -rsSh "$2"
            shift ;;

        git-fetch-merge)
            git fetch upstream master && git merge "$(nixos-version --revision)"
            shift ;;

        pr-pull)
            gh pr checkout -R NixOS/nixpkgs "$2"
            shift ;;

        pr-build)
            nix build github:NixOS/nixpkgs/pull/"$2"/merge#"$3"
            shift ;;

        pr-build-impure)
            NIXPKGS_ALLOW_UNFREE=1 nix build github:NixOS/nixpkgs/pull/"$2"/merge#"$3" --impure
            shift ;;

        impure-run)
            NIXPKGS_ALLOW_UNFREE=1 nix run --impure nixpkgs#"$2"
            shift ;;

        impure-shell)
            NIXPKGS_ALLOW_UNFREE=1 nix shell --impure nixpkgs#"$2"
            shift ;;

        impure-build)
            NIXPKGS_ALLOW_UNFREE=1 nix build --impure nixpkgs#"$2"
            shift ;;

        hash2sri)
            nix hash to-sri --type sha256 "$2"
            shift ;;

        indexdb-update)
            filename="index-x86_64-$(uname | tr '[:upper:]' '[:lower:]')"
            mkdir -p ~/.cache/nix-index
            pushd ~/.cache/nix-index > /dev/null
            wget -q -N https://github.com/Mic92/nix-index-database/releases/latest/download/"$filename"
            ln -f "$filename" files
            popd > /dev/null
            ls -l ~/.cache/nix-index
            shift ;;

        *)
            shift ;;

    esac
done
