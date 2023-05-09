{
  username,
  pkgs,
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
    extraGroups = [
      "wheel"
      "audio"
      "video"
      "networkmanager"
      "lxd"
      "docker"
      "libvirtd"
      "qemu-libvirtd"
      "vboxusers"
      "adbusers"
    ];
  };

  users.users.guest = {
    isNormalUser = true;
    # mkpasswd -m sha-512
    hashedPassword = "$6$OQAkLagK6F4cEAEd$yvAo2bcDs1dOt5F.IFsxh.IDM6mR7k./knHTQz4/EO4z.UXfnTaHphdPY1v.BPPO4CYNBGUQmPRsgyn9XN3Ym/";
    extraGroups = [
      "wheel"
      "audio"
      "video"
      "networkmanager"
      "lxd"
      "docker"
      "libvirtd"
      "qemu-libvirtd"
      "vboxusers"
      "adbusers"
    ];
  };
}
