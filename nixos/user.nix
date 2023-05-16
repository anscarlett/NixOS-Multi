{
  username,
  pkgs,
  lib,
  config,
  ...
}: {
  users = {
    mutableUsers = false;
    # defaultUserShell = pkgs.zsh;
  };

  users.users.${username} = {
    isNormalUser = true;
    # mkpasswd -m sha-512
    hashedPassword = "$6$7LRbX.zmB4lDy/AS$Hi8rzhlSgCTpKsUS/TtdYKNq4ZQfLMMOYmc7jqyD86qK0sL5BWb1FnvzDzMfbzlXg41I76c7/C/g8aBBakSIL0";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMLrQVhdLD9o1Iq17LKFNQ21PaHIAylizOFkvh74FUrz linzway@qq.com"
    ];
    extraGroups =
      [
        "wheel"
        "audio"
        "video"
        "networkmanager"
      ]
      ++ lib.optionals config.virtualisation.lxd.enable ["lxd"]
      ++ lib.optionals config.virtualisation.docker.enable ["docker"]
      ++ lib.optionals config.virtualisation.podman.enable ["podman"]
      ++ lib.optionals config.virtualisation.libvirtd.enable ["libvirtd"]
      # ++ lib.optionals config.virtualisation.virtualbox.host.enable ["vboxusers"]
      ++ lib.optionals config.programs.adb.enable ["adbusers"];
  };

  users.users.guest = {
    isNormalUser = true;
    # passwd
    password = "guest";
    extraGroups =
      [
        "wheel"
        "audio"
        "video"
        "networkmanager"
      ]
      ++ lib.optionals config.virtualisation.lxd.enable ["lxd"]
      ++ lib.optionals config.virtualisation.docker.enable ["docker"]
      ++ lib.optionals config.virtualisation.podman.enable ["podman"]
      ++ lib.optionals config.virtualisation.libvirtd.enable ["libvirtd"]
      # ++ lib.optionals config.virtualisation.virtualbox.host.enable ["vboxusers"]
      ++ lib.optionals config.programs.adb.enable ["adbusers"];
  };

  # security.sudo.wheelNeedsPassword = false;
  # or
  # security.sudo.extraRules = [
  #   {
  #     users = ["${username}"];
  #     commands = [
  #       {
  #         command = "ALL";
  #         options = ["NOPASSWD"];
  #       }
  #     ];
  #   }
  # ];

  #######################################################################
  ## doas
  #######################################################################
  security.sudo.enable = false;

  # security.doas.wheelNeedsPassword = false;

  security.doas = {
    enable = true;
    extraRules = [
      {
        users = ["${username}"];
        noPass = true;
        keepEnv = true;
      }
    ];
  };

  # Add an alias
  environment.shellAliases = {
    sudo = "doas";
    sudoedit = "doas micro";
  };
}
