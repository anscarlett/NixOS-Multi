/*
sudo vi /etc/nix/nix.conf
experimental-features = nix-command flakes
trusted-users = root @wheel iab
substituters = https://mirror.sjtu.edu.cn/nix-channels/store

# find desktop items
sudo sed -i '$aexport XDG_DATA_DIRS=$HOME/.nix-profile/share:$HOME/.share:"${XDG_DATA_DIRS:-/usr/local/share/:/usr/share/}"' /etc/profile.d/nix.sh
*/
{
  pkgs,
  inputs,
  ...
}: {
  home.shellAliases = {};

  home.packages = with pkgs; [
  ];

  programs.home-manager.enable = true;

  nix = {
    registry = {
      n.flake = inputs.nixpkgs;
      nixpkgs.flake = inputs.nixpkgs;
    };
    package = pkgs.nix; # need for nix.settings
    settings = {
      warn-dirty = false;
      experimental-features = [
        "repl-flake"
      ];
    };
  };
}
