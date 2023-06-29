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
  home.shellAliases = {
    nixgl = "nix run --impure github:guibou/nixGL";
  };

  home.packages = with pkgs; [
  ];

  programs.home-manager.enable = true;

  nix = {
    registry = {
      self.flake = inputs.self;
      nixpkgs.flake = inputs.nixpkgs;
      n.flake = inputs.nixpkgs;
    };
    package = pkgs.nix; # need for nix.settings
    settings = {
      warn-dirty = false;
      experimental-features = [
        "nix-command"
        "flakes"
        "repl-flake"
      ];
    };
  };
}
