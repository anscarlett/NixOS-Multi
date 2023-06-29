{
  lib,
  config,
  username,
  ...
}: {
  users = {
    # Forbid create new user by `useradd`
    mutableUsers = false;
    # defaultUserShell = pkgs.zsh;
  };

  users.users.${username} = {
    isNormalUser = true;
    # `mkpasswd`
    hashedPassword = "$y$j9T$aNhZV153pAbvGMeFqjGmn.$iH18jxovF5Huof8U4NNPK/EVWHH75o5x8lRzq8IHZO3";
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
    # `passwd`
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

  # sudo or doas
  mods.doas.enable = true;

  # security.sudo.wheelNeedsPassword = false;
  # or
  security.sudo.extraRules = [
    {
      users = ["${username}"];
      commands = [
        {
          command = "ALL";
          options = ["NOPASSWD"];
        }
      ];
    }
  ];
}
