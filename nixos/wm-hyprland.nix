{
  config,
  pkgs,
  lib,
  inputs,
  username,
  ...
}: {
  imports = [
    ./wm.nix
    inputs.hyprland.nixosModules.default
  ];

  services.greetd.settings = {
    default_session.command = "${lib.getExe pkgs.greetd.tuigreet} --time --cmd Hyprland";
    # Autologin
    initial_session = {
      command = "Hyprland";
      user = "${username}";
    };
  };

  # programs.hyprland.enable = true;

  home-manager.users.${username} = {
    inputs,
    config,
    pkgs,
    ...
  }: {
    imports = [inputs.hyprland.homeManagerModules.default];

    wayland.windowManager.hyprland = {
      enable = true;
      extraConfig = ''
        source=./custom.conf
      '';
    };

    home.packages = with pkgs; [
      # hyprpaper # wallpaper
      (waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
        # fix for workspace
        postPatch = (oldAttrs.postPatch or "") + ''
            sed -i 's/zext_workspace_handle_v1_activate(workspace_handle_);/const std::string command = "hyprctl dispatch workspace " + name_;\n\tsystem(command.c_str());/g' src/modules/wlr/workspace_manager.cpp'';
      }))
    ];
  };
}
